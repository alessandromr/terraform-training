data "aws_ami" "ubuntu-milan" {
  provider = aws.milan
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

resource "aws_instance" "web-milan" {
  provider = aws.milan

  ami           = data.aws_ami.ubuntu-milan.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld Milan"
  }
}
