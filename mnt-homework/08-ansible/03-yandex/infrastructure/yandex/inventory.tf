resource "local_file" "save_inventory" {
#   content  = "${data.template_file.inventory.rendered}"
  content = templatefile("../templates/inventory.tftpl", { instances = module.instance})
  filename = "../../playbook/inventory/inventory.yml"
  file_permission = "0644"
}
