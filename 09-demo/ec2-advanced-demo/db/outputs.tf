output "eip" {
  value = aws_eip.ubuntu-instance_ip.public_ip
}