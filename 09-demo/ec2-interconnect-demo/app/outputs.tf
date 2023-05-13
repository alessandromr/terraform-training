output "instance_eip" {
  value = aws_eip.first_instance_ip.public_ip
}