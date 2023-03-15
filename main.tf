resource "aws_s3_bucket" "b" {
  bucket = "testtohinibuck"

  tags = {
    Name        = "testrohini"
    Environment = "Dev"
  }
}

# Private Subnet
resource "aws_subnet" "pvtsub" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}
# raouting table
resource "aws_route_table" "prvtrtable" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "tester 6"
  }
}

# # resource "aws_internet_gateway" "ig" {
# #   vpc_id = aws_vpc.vpc.id
# #   tags = {
# #     Name        = "ro-igw"
# #     Environment = "dev"
# #   }
# }
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.prvtrtable.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  
  subnet_id      = aws_subnet.pvtsub.id
  route_table_id = aws_route_table.prvtrtable.id
}

# lambda function
