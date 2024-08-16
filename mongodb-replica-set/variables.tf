variable "mongodb_instance_setting" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "key_name" {
  default = ""
}

variable "iam_role" {
  default = ""
}

variable "zone_id" {
  default = ""
}

variable "zone_name" {
  default = ""
}

variable "name" {
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "instance_type" {
  default = "t3.small"
}

variable "data_ebs_volume_size" {
  description = ""
  default     = "8"
}

variable "ami_id" {
  default = "ami-08569b978cc4dfa10"
}

variable "ingress_with_cidr_blocks" {
  type = list(map(any))
}

variable "egress_with_cidr_blocks" {
  type = list(map(any))
}

variable "type" {
  type = string
  default = "gp3"
}

variable "monitoring" {
  type = bool
  default = false
}

variable "ingress_with_source_security_group_id" {
  type = list(map(any))
  default = []
}

variable "ingress_with_self" {
  type = list(map(any))
  default = []
}