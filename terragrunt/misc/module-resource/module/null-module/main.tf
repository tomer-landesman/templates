resource "null_resource" "null" {
}

output "str" {
  value = "1"
}

output "bool" {
  value = true
}

output "num" {
  value = 2
}

output "obj" {
  value = {
    "a" = "b"
  }
}

output "sens" {
  value     = "sensor"
  sensitive = true

}


