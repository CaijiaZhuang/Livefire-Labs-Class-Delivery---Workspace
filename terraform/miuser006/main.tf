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
  type              = "ingress"

  from_port         = "666"
  to_port           = "666"
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "The Port Of The Beast"

  security_group_id = aws_security_group.class_delivery_sg.id                           # Security Group ID to which to attach 
  depends_on        = [aws_security_group.class_delivery_sg]                            # SG needs to exist first
}

# Create Egress Rules
resource "aws_security_group_rule" "egress_rules" {                                   
  type              = "egress"

  from_port         = "666"
  to_port           = "666"
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "The Port Of The Beast"
  
  security_group_id = aws_security_group.class_delivery_sg.id                           # Security Group ID to which to attach 
  depends_on        = [aws_security_group.class_delivery_sg]                            # SG needs to exist first
}
# Get Data for instance(s) id(s)
data "aws_instance" "instance" {
  instance_id = var.awsInstanceId1
}