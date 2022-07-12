variable "awsSgName" {              # Security Group Name
  type = string
}

variable "awsSgTagOwner" {          # Security Group Tag "Owner" value
  type = string
}

variable "awsProviderRegion" {      # AWS Provider Region 
  type = string
}

variable "awsVpcId" {               # AWS VPC Id
  type = string
}

variable "awsInstanceId1" {         # Machine Resource 1 Instance Id(s)
  type    = string
  default = ""                      # Account for when instances is not passed.
}

variable "awsInstanceId2" {         # Machine Resource 2 Instance Id(s)
  type    = string
  default = ""                      # Account for when instances is not passed. 
}

variable "awsInstanceId3" {         # Machine Resource 3 Instance Id(s)
  type    = string
  default = ""                      # Account for when instances is not passed. 
}
variable "awsSgIngressRules" {      # AWS Security Group Ingress Rules
  type = string
}
variable "awsSgEgressRules" {       # AWS Security Group Egress Rules
  type = string
}