resource "aws_elb" "test-elb" {
  name               = "test-terraform-elb"
  availability_zones = ["us-east-1a", "us-east-1b"]

  access_logs {
    bucket   = aws_s3_bucket_acl.Client_bucket-abc.bucket
    interval = 60
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"

  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }
  /*
  instances                   = [aws_instance.foo.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "client-terraform-elb"
  }*/
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.test-autoscaling-group.id
  elb                    = aws_elb.test-elb.id
}