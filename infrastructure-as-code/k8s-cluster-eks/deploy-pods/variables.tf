variable "config_map_name" {
  default = "aws-auth"
  type    = "string"
}

variable "namespace_name" {
  default = "eks-namespace"
  type    = "string"
}

variable "nginx_pod_name" {
  default = "nginx-hashihang"
  type    = "string"
}

variable "nginx_pod_image" {
  default = "boeroboy/hashibo"
  type    = "string"
}

