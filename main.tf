# S3 Backend bucket
resource "aws_s3_bucket" "b" {
  bucket = "testtohinibuck"

  tags = {
    Name        = "testrohini"
    Environment = "Dev"
  }
}

# Private Subnet
resource "aws_subnet" "pvtsub" {
  vpc_id = data.aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}
# raouting table
resource "aws_route_table" "prvtrtable" {
  vpc_id = data.aws_vpc.vpc.id
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
  nat_gateway_id         = data.aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  
  subnet_id      = aws_subnet.pvtsub.id
  route_table_id = aws_route_table.prvtrtable.id
}

# lambda function
provider "archive" {}
data "archive_file" "zip" {
  type        = "zip"
  source_file = "welcome.py"
  output_path = "welcome.zip"
}
data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}
resource "aws_lambda_function" "lambda" {
  function_name = "welcome"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  role    = data.aws_iam_role.lambda.name
  handler = "welcome.lambda_handler"
  runtime = "python3.6"
}