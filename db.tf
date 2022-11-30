# Create RDS Database.

resource "aws_db_instance" "app" {
    identifier             = var.app
    allocated_storage      = 5
    engine                 = "mysql"
    engine_version         = "8.0.31"
    port                   = "3306"
    instance_class         = var.db_instance_type
    db_name                = var.db_name
    username               = var.db_user
    password               = var.db_password
    availability_zone      = var.az_2
    vpc_security_group_ids = ["${aws_security_group.app_db.id}"]
    multi_az               = false
    db_subnet_group_name   = aws_db_subnet_group.app_database_subnet.id
    parameter_group_name   = "default.mysql8.0"
    publicly_accessible    = false
    skip_final_snapshot    = true

    tags = {
    Name = var.app
  }
}