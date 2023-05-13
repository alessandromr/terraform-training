data "aws_ami" "ubuntu-ireland" {
  provider = aws.ireland
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

resource "aws_instance" "web-ireland" {
  provider = aws.ireland

  ami           = data.aws_ami.ubuntu-ireland.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld Ireland"
  }
}
