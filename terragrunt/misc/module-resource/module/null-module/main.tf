provider "aws" {
  region = "us-west-2"
}

resource "null_resource" "test" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

module "nuller" {
  source = "./module/nuller"
}

# s3 bucket
resource "aws_s3_bucket" "example2" {
  bucket = "tomer-l-hamalech-terraform-test-bucket"

  tags = {
    Test = "no"
    La   = "bye"
  }
}

output "bucket" {
  value = aws_s3_bucket.example2.id
}

output "tag" {
  value = aws_s3_bucket.example2.tags
}

output "this" {
  value = null_resource.test.id
}

output "nuller_id" {
  value = module.nuller.id
}

output "nuller_complex" {
  value = module.nuller.complex
}
