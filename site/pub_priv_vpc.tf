resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
      Name = "terraform_vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "terraform_igw"
  }
}
output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

#
# NAT Instance
#
resource "aws_instance" "nat" {
  ami = "ami-a136a9d8" # this is a special ami preconfigured to do NAT
  availability_zone = "eu-west-1a"
  instance_type = "t2.small"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.nat.id}"]
  subnet_id = "${aws_subnet.demo_public.id}"
  associate_public_ip_address = true
  source_dest_check = false
  tags {
      Name = "terraform_nat_instance"
  }
}

resource "aws_eip" "nat" {
  instance = "${aws_instance.nat.id}"
  vpc = true
}

#
# Public Subnet
#
resource "aws_subnet" "demo_public" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "eu-west-1a"
  tags {
      Name = "terraform_public_subnet"
  }
}
output "public_subnet_id" {
  value = "${aws_subnet.demo_public.id}"
}

resource "aws_route_table" "demo_public" {
  vpc_id = "${aws_vpc.default.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags {
      Name = "terraform_public_subnet_route_table"
  }
}

resource "aws_route_table_association" "demo_public" {
  subnet_id = "${aws_subnet.demo_public.id}"
  route_table_id = "${aws_route_table.demo_public.id}"
}

#
# Private Subnet
#
resource "aws_subnet" "demo_private" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "eu-west-1a"
  tags {
      Name = "terraform_private_subnet"
  }
}
output "private_subnet_id" {
  value = "${aws_subnet.demo_private.id}"
}

resource "aws_route_table" "demo_private" {
  vpc_id = "${aws_vpc.default.id}"
  route {
      cidr_block = "0.0.0.0/0"
      instance_id = "${aws_instance.nat.id}"
  }
  tags {
      Name = "terraform_private_subnet_route_table"
  }
}

resource "aws_route_table_association" "demo_private" {
  subnet_id = "${aws_subnet.demo_private.id}"
  route_table_id = "${aws_route_table.demo_private.id}"
}
