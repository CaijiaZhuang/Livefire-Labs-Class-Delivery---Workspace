# Define Local Variables
locals {
  # 1
  awsInstanceId1_hasMultiple = length(regexall("[,]",var.awsInstanceId1)) < 1 ? false : true                              
  awsInstanceId1_obj = jsondecode(replace(replace("[\"${var.awsInstanceId1}\"]","[\"[\"", "[\""),"\"]\"]","\"]"))
  awsInstanceId1_length = local.awsInstanceId1_hasMultiple == true ? length(local.awsInstanceId1_obj) : 0               
  # 2
  awsInstanceId2_hasMultiple = length(regexall("[,]",var.awsInstanceId2)) < 1 ? false : true                              
  awsInstanceId2_obj = jsondecode(replace(replace("[\"${var.awsInstanceId2}\"]","[\"[\"", "[\""),"\"]\"]","\"]"))
  awsInstanceId2_length = local.awsInstanceId2_hasMultiple == true ? length(local.awsInstanceId2_obj) : 0        
  # 3
  awsInstanceId3_hasMultiple = length(regexall("[,]",var.awsInstanceId3)) < 1 ? false : true                              
  awsInstanceId3_obj = jsondecode(replace(replace("[\"${var.awsInstanceId3}\"]","[\"[\"", "[\""),"\"]\"]","\"]"))
  awsInstanceId3_length = local.awsInstanceId3_hasMultiple == true ? length(local.awsInstanceId3_obj) : 0               
}


locals {
  # SG Rules
  awsSgIngressRules_obj = jsondecode(var.awsSgIngressRules)   # Ingress
  awsSgEgressRules_obj  = jsondecode(var.awsSgEgressRules)    # Egress

# Get Instance(s) Id(s)
data "aws_instances" "instances" {
  filter {
    name   = "instance-id"
    values = [
      # Get all instance Id(s) from machine resource 
      local.awsInstanceId1_hasMultiple == false ? local.awsInstanceId1_obj[0] : "",
      local.awsInstanceId1_length == 2 ? local.awsInstanceId1_obj[0] : "", 
      local.awsInstanceId1_length == 2 ? local.awsInstanceId1_obj[1] : "", 
      local.awsInstanceId1_length == 3 ? local.awsInstanceId1_obj[0] : "", 
      local.awsInstanceId1_length == 3 ? local.awsInstanceId1_obj[1] : "", 
      local.awsInstanceId1_length == 3 ? local.awsInstanceId1_obj[2] : "", 
      # Get all instance Id(s) from machine resource
      local.awsInstanceId2_hasMultiple == false ? local.awsInstanceId2_obj[0] : "",
      local.awsInstanceId2_length == 2 ? local.awsInstanceId2_obj[0] : "", 
      local.awsInstanceId2_length == 2 ? local.awsInstanceId2_obj[1] : "", 
      local.awsInstanceId2_length == 3 ? local.awsInstanceId2_obj[0] : "", 
      local.awsInstanceId2_length == 3 ? local.awsInstanceId2_obj[1] : "", 
      local.awsInstanceId2_length == 3 ? local.awsInstanceId2_obj[2] : "" ,
      # Get all instance Id(s) from machine resource
      local.awsInstanceId3_hasMultiple == false ? local.awsInstanceId3_obj[0] : "",
      local.awsInstanceId3_length == 2 ? local.awsInstanceId3_obj[0] : "", 
      local.awsInstanceId3_length == 2 ? local.awsInstanceId3_obj[1] : "", 
      local.awsInstanceId3_length == 3 ? local.awsInstanceId3_obj[0] : "", 
      local.awsInstanceId3_length == 3 ? local.awsInstanceId3_obj[1] : "", 
      local.awsInstanceId3_length == 3 ? local.awsInstanceId3_obj[2] : "" 
      ]
  }
}
  
 # Get Data for instance(s) id(s)
data "aws_instance" "instance" {         
  # instance_id = var.awsInstanceId1                       
  count       = length(data.aws_instances.instances.ids)
  instance_id = data.aws_instances.instances.ids[count.index]
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
  count             = length(local.awsSgIngressRules_obj)                               # Count passed rules
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
  count                = length(data.aws_instance.instance)                             # Iterate over all Instances           
  security_group_id    = aws_security_group.class_delivery_sg.id                        # SG ID
  network_interface_id = data.aws_instance.instance[count.index].network_interface_id                # ENI ID
  depends_on           = [aws_security_group.class_delivery_sg]                         # SG needs to exist first 
}