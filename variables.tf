variable "environment" {
  type    = string
  default = ""
}
variable "managed_by" {
  type    = string
  default = ""
}

#_____VPC________________________#
variable "vpc_name" {type = string}
variable "vpc_cidr_block" {type = string}

#______SUBNETS_____________________#
variable "public_subnets"{
  type        = list(map(string))
  description = "List public subnets setting: cidr_block and availability_zone"
  default     = []
}

variable "private_subnets"{
  type        = list(map(string))
  description = "List public subnets setting: cidr_block and availability_zone"
  default     = []
}