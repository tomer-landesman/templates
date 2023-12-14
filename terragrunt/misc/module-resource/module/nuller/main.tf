resource "null_resource" "nuller" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

output "id" {
  value = null_resource.nuller.id
}

output "complex" {
  value = {
    foo     = "upd22ated"
    lalalal = false
  }

}
