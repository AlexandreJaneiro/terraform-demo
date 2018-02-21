variable "availability_zones" {
  # No spaces allowed between az names!
  default = "eu-west-1a,eu-west-1b,eu-west-1c"
}

#
# From other modules
#
variable "public_subnet_id" {}
variable "webapp_http_inbound_sg_id" {}
