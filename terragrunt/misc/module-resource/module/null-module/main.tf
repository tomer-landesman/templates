resource "null_resource" "null" {
}

output "1" {
  value = "1"
}

output "3" {
  value = true
}

output "4" {
  value = 2
}

output "5" {
  value = {
    "a" = "b"
  }
}


