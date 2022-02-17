output "vpc_id" {
  description = "VPCID"
  value       = aws_vpc.Infravpc.id
}

output "publicip" {
  description = "publicip of instances"
  value       = { for each in aws_instance.server : each.id => each.public_ip }
}
/*
output "publicip" {
  description = "publicip of instances"
  value = aws_instance.server[*].public_ip
}
*/