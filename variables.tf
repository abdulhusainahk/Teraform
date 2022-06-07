variable "host_os" {
  type    = string
  default = "windows"
}
variable "tagtype" {
  type    = string
  default = "dev"
}
variable "ingresscdr" {
  type    = string
  default = "103.170.252.2/32"
}
variable "egresscdr" {
  type    = string
  default = "0.0.0.0/0"
}
variable "instanceTag" {
  type    = string
  default = "main-node"
}
variable "cdr" {
  type    = string
  default = "10.121.0.0/16"
}
variable "startaz" {
  type    = string
  default = null
}
variable "cpu_core_count" {
  type    = number
  default = 1
}
variable "hibernation" {
  type    = bool
  default = false
}
variable "monitoring" {
  type    = bool
  default = false
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "ebs_size" {
  type    = number
  default = 6
}
variable "cpu_threads_per_core" {
  type    = number
  default = 2
}
variable "create_spot_instance" {
  type    = bool
  default = false
}

variable "instance_count" {
  type    = number
  default = 2
}
variable "enclave_options_enabled" {
  type    = bool
  default = false
}
variable "ingress_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cdr         = list(string)
  }))
  default = [{
    description = "ingress rule for ingress http "
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cdr         = ["103.170.252.2/32"]
    }, {
    description = "ingress rule for ingress https "
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cdr         = ["0.0.0.0/0"]
    }, {
    description = "ingress rule for ingress ssh "
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cdr         = ["103.170.252.2/32"]
    }
  ]
}
variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting EC2 instance resources"
  type        = map(string)
  default = {
    create : "10m",
    update : "10m",
    delete : "20m"
  }
}