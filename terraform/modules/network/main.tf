resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
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

resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidrs

  vpc_id            = aws_vpc.this.id
  availability_zone = "${var.region}${each.key}"
  cidr_block        = each.value

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
  igw_routes = [
  ]
}

# resource "aws_route_table" "public" {
#   count = length(var.public_subnet_cidrs) > 0 ? 1 : 0

#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.this.id
#   }

#   tags = {
#     Name = "${var.name}-public"
#   }
# }

# resource "aws_route_table_association" "public" {
#   for_each = var.public_subnet_cidrs

#   subnet_id      = aws_subnet.public[each.key].id
#   route_table_id = aws_route_table.public[0].id
# }

# resource "aws_route_table" "private" {
#   count = length(var.private_subnet_cidrs) > 0 ? 1 : 0

#   vpc_id = aws_vpc.this.id

#   route {}

#   tags = {
#     Name = "${var.name}-private"
#   }
# }

# resource "aws_route_table_association" "private" {
#   for_each = var.private_subnet_cidrs

#   subnet_id      = aws_subnet.private[each.key].id
#   route_table_id = aws_route_table.private[0].id
# }
