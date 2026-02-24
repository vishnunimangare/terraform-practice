
output "instance_id" {
  description = "Public id of instance"
  value = aws_instance.example.id
}
output "instance_type" {
  description = "Instance type"
  value = aws_instance.example.instance_type
}
output "public_ip" {
  description = "PUBLIC ip of instance"
  value = aws_instance.example.public_ip
}
output "instance_dns" {
  description = "DNS value of instance"
  value = aws_instance.example.public_dns
}
output "availability_zone" {
  description = "Availability zone of instance"
  value = aws_instance.example.availability_zone
  
}