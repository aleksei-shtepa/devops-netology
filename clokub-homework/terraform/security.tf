# resource "yandex_vpc_security_group" "k8s-public-services" {
#   name        = "k8s-public-services"
#   description = "Правила группы разрешают подключение к сервисам из интернета. Примените правила только для групп узлов."
#   network_id  = yandex_vpc_network.default.id
#   ingress {
#     protocol          = "TCP"
#     description       = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера и сервисов балансировщика."
#     predefined_target = "loadbalancer_healthchecks"
#     from_port         = 0
#     to_port           = 65535
#   }
#   ingress {
#     protocol          = "ANY"
#     description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
#     predefined_target = "self_security_group"
#     from_port         = 0
#     to_port           = 65535
#   }
# #   ingress {
# #     protocol          = "ANY"
# #     description       = "Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера и сервисов."
# #     v4_cidr_blocks    = concat(yandex_vpc_subnet.mysubnet-a.v4_cidr_blocks, yandex_vpc_subnet.mysubnet-b.v4_cidr_blocks, yandex_vpc_subnet.mysubnet-c.v4_cidr_blocks)
# #     from_port         = 0
# #     to_port           = 65535
# #   }
#   ingress {
#     protocol          = "ICMP"
#     description       = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей."
#     v4_cidr_blocks    = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
#   }
#   ingress {
#     protocol          = "TCP"
#     description       = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
#     v4_cidr_blocks    = ["0.0.0.0/0"]
#     from_port         = 30000
#     to_port           = 32767
#   }
#   egress {
#     protocol          = "ANY"
#     description       = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Yandex Object Storage, Docker Hub и т. д."
#     v4_cidr_blocks    = ["0.0.0.0/0"]
#     from_port         = 0
#     to_port           = 65535
#   }
# }

# resource "yandex_vpc_security_group" "k8s-main-sg" {
#   name        = "k8s-main-sg"
#   description = "Правила группы обеспечивают базовую работоспособность кластера. Примените ее к кластеру и группам узлов."
#   network_id  = "<идентификатор облачной сети>"
#   ingress {
#     protocol          = "TCP"
#     description       = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера и сервисов балансировщика."
#     predefined_target = "loadbalancer_healthchecks"
#     from_port         = 0
#     to_port           = 65535
#   }
#   ingress {
#     protocol          = "ANY"
#     description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
#     predefined_target = "self security group"
#     from_port         = 0
#     to_port           = 65535
#   }
#   ingress {
#     protocol       = "ANY"
#     description    = "Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера и сервисов."
#     v4_cidr_blocks = ["10.96.0.0/16", "10.112.0.0/16"]
#     from_port      = 0
#     to_port        = 65535
#   }
#   ingress {
#     protocol       = "ICMP"
#     description    = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей."
#     v4_cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8", "192.168.0.0/16"]
#   }
#   egress {
#     protocol       = "ANY"
#     description    = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Object Storage, Docker Hub и т. д."
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     from_port      = 0
#     to_port        = 65535
#   }
# }

# resource "yandex_vpc_security_group" "k8s-public-services" {
#   name        = "k8s-public-services"
#   description = "Правила группы разрешают подключение к сервисам из интернета. Примените правила только для групп узлов."
#   network_id  = "<идентификатор облачной сети>"

#   ingress {
#     protocol       = "TCP"
#     description    = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     from_port      = 30000
#     to_port        = 32767
#   }
# }

# resource "yandex_vpc_security_group" "k8s-nodes-ssh-access" {
#   name        = "k8s-nodes-ssh-access"
#   description = "Правила группы разрешают подключение к узлам кластера по SSH. Примените правила только для групп узлов."
#   network_id  = "<идентификатор облачной сети>"

#   ingress {
#     protocol       = "TCP"
#     description    = "Правило разрешает подключение к узлам по SSH с указанных IP-адресов."
#     v4_cidr_blocks = ["85.32.32.22/32"]
#     port           = 22
#   }
# }

# resource "yandex_vpc_security_group" "k8s-master-whitelist" {
#   name        = "k8s-master-whitelist"
#   description = "Правила группы разрешают доступ к API Kubernetes из интернета. Примените правила только к кластеру."
#   network_id  = "<идентификатор облачной сети>"

#   ingress {
#     protocol       = "TCP"
#     description    = "Правило разрешает подключение к API Kubernetes через порт 6443 из указанной сети."
#     v4_cidr_blocks = ["203.0.113.0/24"]
#     port           = 6443
#   }

#   ingress {
#     protocol       = "TCP"
#     description    = "Правило разрешает подключение к API Kubernetes через порт 443 из указанной сети."
#     v4_cidr_blocks = ["203.0.113.0/24"]
#     port           = 443
#   }
# }

# resource "yandex_kubernetes_cluster" "k8s-cluster" {
#   name = "k8s-cluster"
#   cluster_ipv4_range = "10.96.0.0/16"
#   service_ipv4_range = "10.112.0.0/16"
#   ...
#   master {
#     version = "1.20"
#     zonal {
#       zone      = "ru-central1-a"
#       subnet_id = <идентификатор облачной подсети>
#     }

#     security_group_ids = [
#       yandex_vpc_security_group.k8s-main-sg.id,
#       yandex_vpc_security_group.k8s-master-whitelist.id
#     ]
#     ...
#   }
#   ...
# }

# resource "yandex_kubernetes_node_group" "worker-nodes-c" {
#   cluster_id = yandex_kubernetes_cluster.k8s-cluster.id
#   name       = "worker-nodes-c"
#   version    = "1.20"
#   ...
#   instance_template {
#     platform_id = "standard-v3"
#     network_interface {
#       nat                = true
#       subnet_ids         = [<идентификатор облачной подсети>]
#       security_group_ids = [
#         yandex_vpc_security_group.k8s-main-sg.id,
#         yandex_vpc_security_group.k8s-nodes-ssh-access.id,
#         yandex_vpc_security_group.k8s-public-services.id
#       ]
#       ...
#     }
#     ...
#   }
# }
