variable "region" {
  default = "eu-west-1"
}
variable "key_name" {}
variable "instance_type" {
  default = "t2.micro"
}
# Amazon Linux AMI
variable "amis" {
  default = {
    eu-west-1 = "ami-d834aba1"
  }
}
#
# From other modules
#
variable "webapp_http_inbound_sg_id" {}
variable "webapp_ssh_inbound_sg_id" {}
variable "webapp_outbound_sg_id" {}
