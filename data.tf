data "aws_region" "current" {}

data "aws_prefix_list" "private_s3" {
  name = "com.amazonaws.us-east-1.s3"
}
