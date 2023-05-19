data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_network_interface" "ubuntu-instance" {
  subnet_id = data.terraform_remote_state.network.outputs.public_subnets[0]
  security_groups = [
    aws_security_group.instances_connection_sg.id
  ]

  tags = {
    Name = "terraform-training-${terraform.workspace}"
  }
}

resource "aws_eip" "ubuntu-instance_ip" {
  network_interface = aws_network_interface.ubuntu-instance.id
}

resource "aws_instance" "ubuntu-instance" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t3.nano"

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.id
  key_name             = aws_key_pair.ubuntu-instance.key_name

  network_interface {
    network_interface_id = aws_network_interface.ubuntu-instance.id
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

resource "aws_key_pair" "ubuntu-instance" {
  public_key = tls_private_key.ubuntu-instance.public_key_openssh
}

resource "tls_private_key" "ubuntu-instance" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ubuntu-instance" {
  filename = "ubuntu-instance-key"
  content  = tls_private_key.ubuntu-instance.private_key_pem
  file_permission = "0400"
}