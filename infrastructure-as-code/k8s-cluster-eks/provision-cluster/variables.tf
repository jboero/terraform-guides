#
# Variables Configuration
#

variable "cluster-name" {
  default = "terraform-eks-hashihang"
  type    = "string"
}

variable "cluster" {
  default = "kubernetes"
  type    = "string"
}

variable "user" {
  default = "aws"
  type    = "string"
}
