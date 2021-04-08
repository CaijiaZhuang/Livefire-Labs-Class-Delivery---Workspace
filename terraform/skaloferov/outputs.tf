# Security Group Outputs 

output "sg_id" {
  description = "sg_id"
  value   = aws_security_group.class_delivery_sg.id
 }

output "sg_arn" {
  description = "sg_arn"
  value   = aws_security_group.class_delivery_sg.arn
 }

output "sg_name" {
  description = "sg_name"
  value   = aws_security_group.class_delivery_sg.name
 }

output "sg_vpc_id" {
  description = "sg_vpc_id"
  value   = aws_security_group.class_delivery_sg.vpc_id
}

output "sg_owner_id" {
  description = "sg_owner_id"
  value   = aws_security_group.class_delivery_sg.owner_id
}

output "sg_description" {
  description = "sg_description"
  value   = aws_security_group.class_delivery_sg.description
}

output "sg_name_prefix" {
  description = "sg_name_prefix"
  value   = aws_security_group.class_delivery_sg.name_prefix
}

output "sg_revoke_rules_on_delete" {
  description = "sg_revoke_rules_on_delete"
  value   = aws_security_group.class_delivery_sg.revoke_rules_on_delete
}


# Network Interface Outputs 

output "eni_id" {
  description = "eni_id"
  value   = ["${aws_network_interface_sg_attachment.sg_attachment.*.id}"]
}

output "eni_network_interface_id" {
  description = "eni_network_interface_id"
  value   = ["${aws_network_interface_sg_attachment.sg_attachment.*.network_interface_id}"]
}

output "eni_security_group_id" {
  description = "eni_security_group_id"
  value   = ["${aws_network_interface_sg_attachment.sg_attachment.*.security_group_id}"]
}

