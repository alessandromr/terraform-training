resource "aws_autoscaling_group" "windows_asg" {
  name                      = "terraform-training-demo-asg-${terraform.workspace}"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [data.terraform_remote_state.network.outputs.public_subnets[0]]

    launch_template {
      id      = aws_launch_template.windows_lc.id
      version = "$Latest"
    }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  target_group_arns = [aws_lb_target_group.windows_elb.arn]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "terraform-training-demo-asg-windows-instance"
  }
}

resource "aws_launch_template" "windows_lc" {
  name          = "terraform-training-demo-lc-${terraform.workspace}"
  image_id      = var.windows_base_ami
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.instances_connection_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.id
  }
  key_name = aws_key_pair.first_instance.key_name
}

resource "aws_lb" "windows_elb" {
  name               =  "tf-training-elb-${terraform.workspace}"
  load_balancer_type = "application"

  subnets  = data.terraform_remote_state.network.outputs.public_subnets
  security_groups = [aws_security_group.elb_sg.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.windows_elb.arn // Amazon Resource Name (ARN) of the load balancer
  port = 80
  protocol = "HTTP"

  // By default, return a simple 404 page
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "windows_elb" {
  name ="tf-training-elb-tg-${terraform.workspace}"
  port = 80
  protocol = "HTTP"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "windows_elb_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.windows_elb.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}