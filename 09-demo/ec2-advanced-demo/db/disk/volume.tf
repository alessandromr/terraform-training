resource "aws_ebs_volume" "mongo_additional_volume" {
  availability_zone = var.az
  size              = 20
  encrypted = true

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_volume_attachment" "mongo_additional_volume" {
  device_name = var.device_name
  instance_id = var.instance_id
  volume_id   = aws_ebs_volume.mongo_additional_volume.id
}