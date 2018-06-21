#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "hashihang" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "terraform-eks-hashihang-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "hashihang" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.hashihang.id}"

  tags = "${
    map(
     "Name", "terraform-eks-hashihang-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "hashihang" {
  vpc_id = "${aws_vpc.hashihang.id}"

  tags {
    Name = "terraform-eks-hashihang"
  }
}

resource "aws_route_table" "hashihang" {
  vpc_id = "${aws_vpc.hashihang.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.hashihang.id}"
  }
}

resource "aws_route_table_association" "hashihang" {
  count = 2

  subnet_id      = "${aws_subnet.hashihang.*.id[count.index]}"
  route_table_id = "${aws_route_table.hashihang.id}"
}
