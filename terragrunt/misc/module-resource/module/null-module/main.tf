resource "null_resource" "null" {
}

module "nuller_module" {
  source = "../nuller-module"
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
