variable "ingress_rules" {
  type = list(object({
    description = string
    from_port = number
    to_port= number
    protocol=string
    cdr = list(string)
  }))
  default = []
}
variable "egresscdr" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "tagtype" {
  type = string
}