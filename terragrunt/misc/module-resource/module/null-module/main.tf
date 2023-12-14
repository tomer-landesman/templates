resource "null_resource" "null" {
}

output "update" {
  value = {
    foo    = "keep"
    baz    = "change-me"
    remove = "remove me"
  }
}

output "remove" {
  value = {
    foo = "bar"
    baz = "qux"
  }
}
