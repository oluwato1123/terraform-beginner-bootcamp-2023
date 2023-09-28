#Random String rules
#https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "bucket_name" {
  length  = 32
  special = false
  lower   = true
  upper   = false
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket.html
#Bucket naming rules
#https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result

  tags = {
    userUuid = var.user_uuid
  }
}



