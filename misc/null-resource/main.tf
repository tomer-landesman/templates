terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"

    }
  }
}

resource "null_resource" "null" {
  count = 3
}

resource "aws_s3_bucket" "tomer-test-bucket" {
  bucket = "tomer-test-bucket2"

}
