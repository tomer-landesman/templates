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

resource "aws_instance" "example_server" {
  ami           = "ami-04e914639d0cca79a"
  instance_type = "t2.micro"

  tags = {
    Name       = "JacksBlogExample"
    AnotherTag = "AnotherVasdlue"
  }
}
output "bucket" {
  value = aws_instance.example_server.id
}

output "tag" {
  value = aws_instance.example_server.tags
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
