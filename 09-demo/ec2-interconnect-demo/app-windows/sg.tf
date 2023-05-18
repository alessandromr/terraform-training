
resource "aws_security_group" "instances_connection_sg" {
  name   = "terraform-training-${terraform.workspace}"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }
  ingress {
    from_port   = 3389
    protocol    = "tcp"
    to_port     = 3389
    cidr_blocks = ["2.199.193.90/32"]
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb_sg" {
  name   = "terraform-training-elb-sg-${terraform.workspace}"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }
  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
