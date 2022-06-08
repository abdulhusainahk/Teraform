output "public_ip" {
  value = aws_instance.main_node.*.public_ip
}
output "private_ip" {
  value = aws_instance.main_node.*.private_ip
}
output "public_dns" {
  value = aws_instance.main_node.*.public_dns
}
output "instance_state" {
  value = aws_instance.main_node.*.instance_state
}