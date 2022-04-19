resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.name
  }
}

resource "aws_eip" "ext_nat_gw" {
  vpc = true
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.ext_nat_gw.id
  subnet_id     = aws_subnet.public["a"].id

  tags = {
    Name = "external-nat-gw"
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidrs

  vpc_id            = aws_vpc.this.id
  availability_zone = "${var.region}${each.key}"
  cidr_block        = each.value

  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "${var.name}-public-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnet_cidrs

  vpc_id            = aws_vpc.this.id
  availability_zone = "${var.region}${each.key}"
  cidr_block        = each.value

  tags = {
    Name = "${var.name}-private-${each.key}"
  }
}

module "public_routes" {
  count = length(var.public_subnet_cidrs) > 0 ? 1 : 0

  source = "./routes"

  name       = "${var.name}-public"
  vpc_id     = aws_vpc.this.id
  subnet_ids = [for s in aws_subnet.public : s.id]
  igw_routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.this.id
    }
  ]
}

module "private_routes" {
  count = length(var.private_subnet_cidrs) > 0 ? 1 : 0

  source = "./routes"

  name       = "${var.name}-private"
  vpc_id     = aws_vpc.this.id
  subnet_ids = [for s in aws_subnet.private : s.id]
  nat_gw_routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this.id
    }
  ]
}
