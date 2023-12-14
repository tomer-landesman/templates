resource "null_resource" "test" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

output "this" {
  value = null_resource.test.id
}
