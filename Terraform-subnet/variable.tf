variable "cdr" {
  type=string
}
variable "az" {
  type=string
}
variable "vpc_id" {
  type=string
}
variable "tags" {
  type=map(string)
}
variable "map_public_ip_on_launch" {
  type = bool
}