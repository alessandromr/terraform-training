#resource "aws_route53_zone" "internal_dns" {
#  name = "demo-project.internal"
#
#  vpc {
#    vpc_id = data.terraform_remote_state.network.outputs.vpc_id
#  }
#}
#
#resource "aws_route53_record" "mongodb" {
#  name    = "mongo.demo-project.internal"
#  type    = "A"
#  zone_id = aws_route53_zone.internal_dns.id
#  ttl = 60
#
#  records = [
#    aws_instance.db-instance.private_ip
#  ]
#}