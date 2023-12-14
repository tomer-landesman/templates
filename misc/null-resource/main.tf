provider "aws" {
  region = "us-west-2"
}

resource "null_resource" "test" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

resource "aws_instance" "example_server" {
  ami           = "ami-04e914639d0cca79a"
  instance_type = "t2.micro"

  tags = {
    Name        = "JacksBlogExample"
    another_tag = "AnotherValue"
  }
}
output "bucket" {
  value = 1
}

output "tag" {
  value = aws_instance.example_server.tags
}

output "this" {
  value = null_resource.test.id
}
