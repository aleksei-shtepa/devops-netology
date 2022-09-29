resource "local_file" "save_inventory" {
#   content  = "${data.template_file.inventory.rendered}"
  content = templatefile("../templates/inventory.tftpl", { instances = module.instance})
  filename = "../../inventory/cicd/hosts.yml"
  file_permission = "0644"
}
