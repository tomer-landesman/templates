resource "null_resource" "null" {
}

output "nuller_module_output" {
  value = {
    foo = "bar"
    baz = "qux"
  }
}
