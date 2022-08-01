output "instance" {
  value = {
    for k, v in module.instance : k => v.ip
  }

  depends_on = [module.instance]
}


# output "clickhouse" {
#   value = module.instance.host
# }

# output "vector" {
#   value = module.vector.host
# }

# output "app" {
#   value = module.app.host
# }

# output "inventory" {
#   value = <<EOT
# %{ for k, v in module.instance ~}
# ${k}:
#   hosts:
#     ${k}:
#       ansible_host: ${v.ip}
#       ansible_user: ${k}
# %{ endfor ~}
# EOT
# }

# output "internal_ip_address_vm_1" {
#   value = yandex_compute_instance.clickhouse.network_interface.0.ip_address
# }

# output "internal_ip_address_vm_2" {
#   value = yandex_compute_instance.vector.network_interface.0.ip_address
# }

# output "subnet-1" {
#   value = yandex_vpc_subnet.subnet-1.id
# }

# output "user" {
#   value = yandex_compute_instance.clickhouse.metadata
# }