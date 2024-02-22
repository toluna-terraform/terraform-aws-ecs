#------------------------------------------
# data.tf
# Module: ECS
#------------------------------------------

# current AWS Region
data "aws_region" "current" {}

# vpce prefix list
data "aws_prefix_list" "private_s3" {
  name = "com.amazonaws.us-east-1.s3"
}

# current account id
data "aws_caller_identity" "current" {}

#check if initial image exists
data "external" "current_service_image" {
  program = ["${path.module}/files/get_container_image.sh"]
  query = {
    app_name = "${var.app_name}"
    image_name = "${var.app_container_image}"
    aws_profile = "${var.aws_profile}"
  }
}
