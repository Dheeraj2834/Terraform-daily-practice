# variable "ingress_ports" {
#   default = [22, 80, 443]
# }


variable "ingress_rules" {
  default = {
    22 = {
      cidr_blocks = ["192.168.1.0/24"]
    }
    80 = {
      cidr_blocks = ["0.0.0.0/0"]
    }
    443 = {
      cidr_blocks = ["0.0.0.0/0"]
    }
    8080 = {
      cidr_blocks = ["10.0.0.0/16"]
    }
  }
}