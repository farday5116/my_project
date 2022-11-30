variable "aws_access_key" {
  description = "AWS IAM Access Key"
}

variable "aws_secret_key" {
  description = "AWS IAM Secret Key"
}

variable "region" {
  description = "AWS Region"
  default     = "eu-west-1" 
}

variable "az_2" {
  description = "Second AZ"
  default     = "eu-west-1b" 
}

variable "app" {
  description = "App name"
  default     = "wordpress" 
}

variable "app_db" {
  description = "RDS name"
  default     = "wordpress_db" 
}

variable "app_lb" {
  description = "ALB name"
  default     = "wordpress_loadbalancer" 
}

variable "ecs_service_count" {
  description = "ECS Service Count"
  default     = "1" 
}

variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "app_container" {
  description = "App Container name"
  default     = "wordpress_ecs" 
}

variable "app_ec2" {
  description = "App EC2"
  default     = "wordpress_ec2" 
}

variable "local_cidr_blocks" {
  description = "Local CIDR Block for EC2 Access"
}

variable "vpc_cidr_block" {
  description = "VPC subnet"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block_alpha" {
  description = "Public Subnet"
  default     = "10.1.1.0/24"
}

variable "public_subnet_cidr_block_bravo" {
  description = "Public Subnet"
  default     = "10.1.2.0/24"
}

variable "private_subnet_cidr_block" {
  description = "Private Subnet"
  default     = "10.1.3.0/24"
}

variable "ecs_cluster_name" {
  description = "ECS cluster Name"
  default     = "wordpress"
}

variable "ami" {
  description = "ECS Container Instance AMI"
  default = "ami-07982a5ff6cf62e53"
}

variable "instance_type" {
  description = "EC2 instance type"
  default = "t2.micro"
}

variable "db_instance_type" {
  description = "RDS instance type"
  default = "db.t2.micro"
}

variable "key_name" {
  description = "SSH key for EC2 instance."
  default     = "wordpress"
}

variable "db_name" {
  description = "RDS DB name"
  default = "wordpressdb"
}

variable "db_user" {
  description = "RDS DB username"
  default = "wordpress"
}

variable "db_password" {
  description = "RDS DB password"
}

variable "website_title" {
  description = "Website title"
  default = "Hello World"
}

variable "app_user" {
  description = "App username"
}

variable "app_password" {
  description = "App password"
}

variable "app_mail" {
  description = "App email address"
}

variable "port" {
  description = "App port"
  default = "80"
}

variable "cpu" {
  description = "App CPU allocation"
  default = "10"
}

variable "memory" {
  description = "App Memory allocation"
  default = "300"
}

variable "app_image" {
  description = "App image"
  default = "wordpress:latest"
}

# If you want to have HTTPS, you will need a domain name. You can uncomment the below and add your FQDN that you have purchased.

#variable "root_domain_name" {
#  type    = string
#}