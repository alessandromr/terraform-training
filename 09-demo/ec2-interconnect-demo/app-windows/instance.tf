data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}

resource "aws_network_interface" "foo" {
  subnet_id = data.terraform_remote_state.network.outputs.public_subnets[0]
  security_groups = [
    aws_security_group.instances_connection_sg.id
  ]

  tags = {
    Name = "terraform-training-${terraform.workspace}"
  }
}

resource "aws_eip" "first_instance_ip" {
  network_interface = aws_network_interface.foo.id
}

resource "aws_instance" "first_instance" {
  ami           = data.aws_ami.windows.image_id
  instance_type = "t3.medium"

  iam_instance_profile = aws_iam_instance_profile.instance_profile.id
  key_name             = aws_key_pair.first_instance.key_name

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  ebs_block_device {
    device_name = "/dev/sdd"
    volume_type = "gp3"
    volume_size = 50
    encrypted   = true
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm_policy
  ]

  tags = {
    Name = "terraform-training-instance-${terraform.workspace}"
  }
}

resource "aws_key_pair" "first_instance" {
  public_key = tls_private_key.rsa-4096-example.public_key_openssh
}

resource "tls_private_key" "rsa-4096-example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_ssm_parameter" "ssh_private_key" {
  name  = "/terraform-training-instance/private-key"
  type  = "SecureString"
  value = tls_private_key.rsa-4096-example.private_key_pem
}
