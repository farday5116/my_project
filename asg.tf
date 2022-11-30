# Create Launch Template

resource "aws_launch_template" "app" {
  name_prefix                 = var.app
  image_id                    = var.ami
  instance_type               = var.instance_type
  iam_instance_profile {
    name = var.app_ec2
  }
  key_name                    = var.key_name
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = ["${aws_security_group.wordpress_ec2.id}"]
    subnet_id                   = "${element(module.vpc.public_subnets, 0)}"
    delete_on_termination       = true 
  }
  user_data                   = "${base64encode(data.template_file.ec2.rendered)}"

  lifecycle {
    create_before_destroy = true
  }
}

# Create Auto Scaling Group

resource "aws_autoscaling_group" "app" {
  name                      = var.ecs_cluster_name
  launch_template {
    id                      = aws_launch_template.app.id
    version                 = "${aws_launch_template.app.latest_version}"
  }
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = module.vpc.public_subnets
  #target_group_arns         = ["${aws_lb_target_group.app.arn}"]
  protect_from_scale_in     = "true"

  tag {
    key                     = "Name"
    value                   = var.app
    propagate_at_launch     = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

# ASG Policies 

# Scale up alarm

resource "aws_autoscaling_policy" "CPUPolicyScaleup" {
  name                   = "CPUPolicyScaleup"
  autoscaling_group_name = "${aws_autoscaling_group.app.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmScaleup" {
  alarm_name              = "CPUAlarmScaleup"
  alarm_description       = "CPUAlarmScaleup"
  comparison_operator     = "GreaterThanOrEqualToThreshold"
  evaluation_periods      = "2"
  metric_name             = "CPUUtilization"
  namespace               = "AWS/EC2"
  period                  = "120"
  statistic               = "Average"
  threshold               = "45"
  dimensions              = {
    "AutoScalingGroupName" = "aws_autoscaling_group.app.name"
  }
  actions_enabled         = true
  alarm_actions           = ["${aws_autoscaling_policy.CPUPolicyScaleup.arn}"]
}

# Scale down alarm

resource "aws_autoscaling_policy" "CPUPolicyScaledown" {
  name                   = "CPUPolicyScaledown"
  autoscaling_group_name = "${aws_autoscaling_group.app.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "CPUAlarmScaledown" {
  alarm_name             = "CPUAlarmScaledown"
  alarm_description      = "CPUAlarmScaledown"
  comparison_operator    = "LessThanOrEqualToThreshold"
  evaluation_periods     = "2"
  metric_name            = "CPUUtilization"
  namespace              = "AWS/EC2"
  period                 = "120"
  statistic              = "Average"
  threshold              = "10"
  dimensions             = {
    "AutoScalingGroupName" = "aws_autoscaling_group.app.name"
  }
  actions_enabled        = true
  alarm_actions          = ["${aws_autoscaling_policy.CPUPolicyScaledown.arn}"]
}