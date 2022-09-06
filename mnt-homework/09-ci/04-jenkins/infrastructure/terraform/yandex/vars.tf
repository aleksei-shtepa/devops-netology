variable "yc_token" { default = "" }

variable "yc_cloud_id" { default = "" }

variable "yc_folder_id" { default = "" }

variable "yc_region" { default = "ru-central1-a" }

# locals {
#   cores = {
#     default = 1
#     stage = 2
#     prod = 2
#   }
#   disk_size = {
#     default = 10
#     stage = 20
#     prod = 40
#   }
#   instance_count = {
#     default = 1
#     stage = 1
#     prod = 2
#   }
#   vpc_subnets = {
#     default = [
#       {
#         zone = var.yc_region
#         v4_cidr_blocks = ["10.128.0.0/24"]
#       }
#     ]
#     stage = [
#       {
#         "v4_cidr_blocks": [
#           "10.128.0.0/24"
#         ],
#         "zone": var.yc_region
#       }
#     ]
#     prod = [
#       {
#         zone           = "ru-central1-a"
#         v4_cidr_blocks = ["10.128.0.0/24"]
#       },
#       {
#         zone           = "ru-central1-b"
#         v4_cidr_blocks = ["10.129.0.0/24"]
#       }
#     ]
#   }
#   nodes_name = {
#     pervak = "Test Pervak Demo"
#     vtoryak = "Test Vtoryak Demo"
#     tretyak = "Test Tretyak Demo"
#   }
# }