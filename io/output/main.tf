resource "null_resource" "name" {
  count = 6
}

variable "circle" {
  
}

output "name" {
  value = "Shalom ani po"
}

output "new_one" {
  value = "Shalom ani new"
}