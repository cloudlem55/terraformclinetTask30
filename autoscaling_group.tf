resource "aws_placement_group" "test" {
  name     = "test"
  strategy = "spread"
}



/*data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Amazon Linux 2 Kernel 5.10 AMI 2.0.20220606.1 x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}
*/


resource "aws_launch_configuration" "test-launch-config" {
  name_prefix   = "terraform-lc-example-"
  image_id      = "ami-098e42ae54c764c25"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "test-autoscaling-group" {
  name                      = "terraform-test"
  min_size                  = 1
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true
  placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.test-launch-config.name
  vpc_zone_identifier       = [aws_subnet.test-subnet-2.id, aws_subnet.test-subnet.id]
  
  initial_lifecycle_hook {
    name                 = "foobar"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 2000
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

    notification_metadata = <<EOF
{
  "Launch": "New_instance is being deployed"
}

lifecycle {
    create_before_destroy = true
  }
EOF

    #  notification_target_arn = "arn:aws:sqs:us-east-1:246020872451:terraform*"
      # role_arn                = "arn:aws:iam::162727731654:role/S3Access"
      # role_arn                = "arn:aws:iam::246020872451:user/terraform"
  }

  tag {
    key                 = "test"
    value               = "deployment"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "lorem"
    value               = "ipsum"
    propagate_at_launch = false
  }
}