# Create Cloudwatch Log Group.

resource "aws_cloudwatch_log_group" "app" {
    name              = "/ecs/${var.app}"
    retention_in_days = 5

    tags = {
        Name = var.app
    }
}

# Create Cloudwatch Log Stream.

resource "aws_cloudwatch_log_stream" "app" {
    name           = var.app
    log_group_name = aws_cloudwatch_log_group.app.name
}