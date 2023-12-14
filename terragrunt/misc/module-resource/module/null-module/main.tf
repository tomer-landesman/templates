resource "null_resource" "test" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

module "nuller" {
  source = "./module/nuller"
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
