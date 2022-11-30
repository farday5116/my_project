#### ================================================================================

### Title: Wordpress Terraform Deployment using AWS ECS & EC2

#### ================================================================================

****

**Overview**

  

This is a guide on how to deploy the following Terraform deployment. It deploys a Wordpress container website in AWS ECS, which is running on EC2 instances.

  

**Contents:**

  

This deployment consists of several parts. Its divided into an Autoscaling, Loadbalancer, IAM, DB, Cloudwatch, Networking, the Container app file and in addition the ACM Certificate Manager and Route 53 with the option for using HTTPS, should you have an already purchased domain, you would like to use over HTTPS. 

The deploy uses AWS EC2 instances on an ASG, to register with the AWS ECS Cluster and have the ECS Service deploy an ECS Container in the form of a Task Definition onto the EC2 instance. It then uses an AWS ALB Load Balancer to access the container website and allows you to get to the Wordpress App signin page. You can then enable HTTPS by uncommenting the HTTPS and Route 53 resources to create an AWS ACM Cert for you (but you must already have bought a domain from either AWS or another Registrar and added that domain to Route 53 Service already).

There is also Cloudwatch monitoring for the Autoscaling Group and Cloudwatch log streaming and Log Groups to help you get the logs of the Wordpress Container for Troubleshooting purposes.

The Terraform deploy is interactive, only imputing the minimal values to allow for customization.


**Note:** If you are running this Terraform deployment, then you will either need an IAM USER or Role with the correct access to the above mentioned resources. If you are using an IAM USER, you may need to export the AWS environment variables ==AWS_REGION==, ==AWS_SECRET_ACCESS_KEY== and ==AWS_ACCESS_KEY_ID== in your shell environment.

  

**The various parts of the deploy have files The file names are called:**

*asg.tf*

*loadbalancer.tf*

*iam.tf*

*db.tf*

*cloudwatch.tf*

*networking.tf*

**This file houses the main ECS deployment:**

*main.tf*

**In addition, we have in the container file:**

 *wordpress.json*

**We also have the EC2 instance bootstrap script to register the EC2 instance on an ASG to the ECS Cluster:**

  *script.sh*

  **To enable HTTPS and add a domain and its Record Sets to AWS for HTTPS, we have these files:**

*cert.tf*

*route53.tf*

**The AWS access and login file is called:**

*aws.tf*

**This file is where we keep the variables. Notice that I have left some without a default variable to allow you to input it in for customization. Feel free to add in variables statically as default though:**

*variables.tf*

**Lastly, we have the README file in markdown, which you are now reading:**

*README.md*

#

#### The deployment is divided into five parts:

  
1. **STAGE 1 - _Create a Terraform State S3 Bucket and upload SSH key_**

2.  **STAGE 2 - _Enable/Disable HTTPS_**

3.  **STAGE 3 - _Terraform Init_**

4.  **STAGE 4 - _Terraform Plan_**

5. **STAGE 5 - _Terraform Apply_**

**STAGE 1 -** Starting off you will be creating an S3 bucket to store your Terraform state file. Then you can create your SSH key in EC2. 

Follow the steps below:
1. Create an S3 bucket using the guide in the link below. Then in the *aws.tf* file, replace ==<"insert S3 bucket here">== with the name of your S3 Bucket.
*https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html*

2. Create your EC2 SSH key via these steps below:
*https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html*

**STAGE 2 -** In this stage you should first decide if you are going to Enable HTTPS with a domain, or keep it HTTP using the ALB URL. If you would like to just have ==HTTP==, then leave the deployment as is and move on to ==**stage 3**==.

However, if you would like to use ==HTTPS== then there is a few things you will need to do:

1. Firstly you will have to have purchased  a domain (either with AWS Route 53 Registrar, or via another Registrar) and added it to Route 53 domain service. This guide doesn't cover getting your own domain (cause it costs money). If you want to get a domain or add your domain to Route 53, please follow the steps in this link below first:

*https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html*

2. Once done, uncomment all the resource blocks in the *cert.tf* and *route53.tf* files.

3. In the *variables.tf* file uncomment out the ==root_domain_name== resource.

4. In the *loadbalancer.tf*, under ==aws_lb_listener==, uncomment the ==certificate_arn==, ==ssl_policy== and ==depends_on==. In the ==protocol== change the ==HTTP== to ==HTTPS==.

#

**STAGE 3 -** Run a Terraform Init. The Terraform deployment makes use of the Terraform module VPC, to allow easier vpc configuration.

 **Run this command:**

> terraform init

#

**STAGE 4 -** Once the Terraform S3 bucket backend has been initialized you can run a Terraform Plan to see the build. If you dont want to do a plan, then you can just skip to ==**stage 5**==.

 **Run this command:**

> terraform plan

The following variables will prompt themselves to you:

1. var.app_mail : "App email address" = The email address you'd like to use in Wordpress. 
2. var.app_password : "App password" = The Wordpress user password you want to use. 
3. var.app_user : "App username" = The Wordpress user name you want to use.
4. var.aws_access_key : "AWS IAM Access Key" = You IAM Access Key you will be using.
5. var.aws_secret_key : "AWS IAM Secret Key" = You IAM Secret Key you will be using.
6. var.db_password : "RDS DB password" = Set the RDS DB Password.
7. var.key_name : "SSH key for EC2 instance" = Name of the SSH Key you uploaded to EC2.
8. var.local_cidr_blocks : "Local CIDR Block for EC2 Access" = Your local CIDR to allow you EC2 ssh access.

Once you've finished all the prompts the Terraform plan will proceed. You could bypass this by using the ==-var=key=value== or setting them as ==default="value"== inside the ==*variables.tf*== file.

#

  
**STAGE 5 -** Once the planning in done and you are happy proceed, you can do a terraform apply. The same input variables as ==**stage 4**== will be present.

 **Run this command:**

> terraform apply

Once done enter =="yes"== without quotes. Wait for the deployment to complete. An output URL will take you to the Wordpress Admin signin page (URL will be the HTTP ALB URL or Route 53 HTTPS URL depending on what you did in ==stage 2==).
#


