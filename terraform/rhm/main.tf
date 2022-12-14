locals {
  # SG Rules
  awsSgIngressRules_obj = jsondecode(var.awsSgIngressRules)   # Ingress
  awsSgEgressRules_obj  = jsondecode(var.awsSgEgressRules)    # Egress
}

# Get Data for instance(s) id(s)
data "aws_instance" "instance" {
  instance_id = var.awsInstanceId1
}

# Create Security Group
resource "aws_security_group" "class_delivery_sg" {       
  name        = "class-delivery-${var.awsSgName}"                                       # SG Name
  vpc_id      = var.awsVpcId                                                            # SG VPC ID
  description = "class-delivery"                                                        # SG Description
  tags = {                                                                              # SG Tags to assign
    cas-resource-desc  = "class-delivery",
    cas-resource-owner = var.awsSgTagOwner,
  }
}


# Create Ingress Rules
resource "aws_security_group_rule" "ingress_rules" {                   
  count             = length(local.awsSgIngressRules_obj)               
  type              = "ingress"

  from_port         = local.awsSgIngressRules_obj[count.index].from_port
  to_port           = local.awsSgIngressRules_obj[count.index].to_port
  protocol          = local.awsSgIngressRules_obj[count.index].protocol
  cidr_blocks       = ["${local.awsSgIngressRules_obj[count.index].cidr_blocks}"]
  description       = local.awsSgIngressRules_obj[count.index].description

  security_group_id = aws_security_group.class_delivery_sg.id                           # Security Group ID to which to attach 
  depends_on        = [aws_security_group.class_delivery_sg]                            # SG needs to exist first
}

# Create Egress Rules
resource "aws_security_group_rule" "egress_rules" {                                   
  count             = length(local.awsSgEgressRules_obj)                                # Count passed rules
  type              = "egress"
  from_port         = local.awsSgEgressRules_obj[count.index].from_port
  to_port           = local.awsSgEgressRules_obj[count.index].to_port
  protocol          = local.awsSgEgressRules_obj[count.index].protocol
  cidr_blocks       = ["${local.awsSgIngressRules_obj[count.index].cidr_blocks}"]
  description       = local.awsSgEgressRules_obj[count.index].description
  
  security_group_id = aws_security_group.class_delivery_sg.id                           # Security Group ID to which to attach 
  depends_on        = [aws_security_group.class_delivery_sg]                            # SG needs to exist first
}

# Attach Instance(s) eni(s) to the Security Group
resource "aws_network_interface_sg_attachment" "sg_attachment" {                        
  security_group_id    = aws_security_group.class_delivery_sg.id                        # SG ID
  network_interface_id = data.aws_instance.instance.network_interface_id                # ENI ID
  depends_on           = [aws_security_group.class_delivery_sg]                         # SG needs to exist first 
}
