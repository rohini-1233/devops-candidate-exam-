provider "aws" {
  region  = "eu-west-1" # Don't change the region
}

# Add your S3 backend configuration here
 backend "s3" {
    bucket         = "aws_s3_bucket.b.id"
    key            = "rohini.nere"
    region         = "eu-west-1"
 
  }