#resource "aws_network_interface" "db-instance" {
#  subnet_id = data.terraform_remote_state.network.outputs.public_subnets[0]
#  security_groups = [
#    aws_security_group.instances_connection_sg.id
#  ]
#
#  tags = {
#    Name = "terraform-training-${terraform.workspace}"
#  }
#}
#
#resource "aws_eip" "db-instance" {
#  network_interface = aws_network_interface.db-instance.id
#}
#
#module "volume" {
#  source = "./disk"
#
#  az          = data.terraform_remote_state.network.outputs.azs[0]
#  device_name = "/dev/xvdb"
#  instance_id = aws_instance.db-instance.id
#}
#
#resource "aws_instance" "db-instance" {
#  ami           = var.mongo_ami_id
#  instance_type = "t3.medium"
#
#  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.id
#  key_name             = aws_key_pair.db-instance.key_name
#
#  network_interface {
#    network_interface_id = aws_network_interface.db-instance.id
#    device_index         = 0
#  }
#
#  credit_specification {
#    cpu_credits = "unlimited"
#  }
#
#  depends_on = [
#    aws_iam_role_policy_attachment.ssm_policy
#  ]
#
#  tags = {
#    Name = "terraform-training-mongodb-${terraform.workspace}"
#  }
#}
#
#resource "aws_key_pair" "db-instance" {
#  public_key = tls_private_key.db-instance.public_key_openssh
#}
#
#resource "tls_private_key" "db-instance" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#}
#
#resource "local_file" "ssh_private_key" {
#  filename = "db-instance-key"
#  content  = tls_private_key.db-instance.private_key_pem
#  file_permission = "0400"
#}