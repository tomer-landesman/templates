resource "null_resource" "null" {
}

output "update" {
  value = {
    foo = "keep"
    baz = "changed-var"
  }
}

output "created" {
  value = {
    foo = "bar"
    baz = "qux"
  }
}
