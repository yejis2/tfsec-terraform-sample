provider "aws" {
  region = "ap-northeast-2"
}

terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
       # Replace this with your bucket name!
      bucket = "terraform-remote-state-testbkt"
      key = "global/s3/terraform.tfstate"
      region= "ap-northeast-2"
      # Replace this with your DynamoDB table name!
      dynamodb_table = "terraform-remote-state-dynamo"
      encrypt        = true
     }
}

#### Remote State Data Source ####
data "aws_availability_zones" "all" {}
