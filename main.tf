# Container template.

data "template_file" "app_container" {
  template = "${file("wordpress.json")}"

  vars = {
    db_host            = aws_db_instance.app.endpoint
    db_name            = var.db_name
    db_user            = var.db_user
    db_password        = var.db_password
    website_title      = var.website_title
    app_user           = var.app_user
    app_password       = var.app_password
    app_mail           = var.app_mail
    port               = var.port
    memory             = var.memory
    cpu                = var.cpu
    container_name     = var.app
    app_image          = var.app_image
  }
}

data "template_file" "ec2" {
  template = "${file("script.sh")}"

  vars = {
    ecs_cluster_app = aws_ecs_cluster.app.name
  }
}

# Create ECS.

resource "aws_ecs_cluster" "app" {
    name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "app" {
    family = var.app
    container_definitions = "${data.template_file.app_container.rendered}"
    execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_service" "app" {
    name            = var.app
    cluster         = aws_ecs_cluster.app.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count   = var.ecs_service_count
    depends_on      = [aws_lb_listener.app]
    launch_type     = "EC2"
    ordered_placement_strategy {
        type  = "binpack"
        field = "cpu"
    }
    load_balancer {
        target_group_arn = aws_lb_target_group.app.arn
        container_name = var.app
        container_port = var.port
    }
}

# Terraform Outputs.

output "wordpress_alb_url" {
    value = "http://${aws_lb.app.dns_name}"
}

# If you wish to enable get the HTTPS url when using AWS ACM, then uncomment the below:

#output "wordpress_dns_url" {
#    value = "https://${var.app}.${var.root_domain_name}"
#}