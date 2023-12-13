resource "null_resource" "null" {
}

output "str" {
  value       = "1"
  description = "this is a string"
}

output "bool" {
  value       = true
  description = "this is a bool"

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


