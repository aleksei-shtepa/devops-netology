
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

> - Опишите своими словами основные преимущества применения на практике IaaC паттернов.

1. Единообразие среды для разработки, тестирования и эксплуатации программного обеспечения. Единожды описанная конфигурация многократно воссоздаётся для требуемой среды.
2. Стабильность конфигураций однотипных сред. Изменение отражённые в конфигурации отражаются на всех экземплярах.
3. Ускорение процессов жизненного цикла программного продукта за счёт автоматизации развёртывания сред сборки, тестирования и эксплуатации. Формализация конфигурации полностью автоматизирует процесс создания среды и сокращает время её формирования.

> - Какой из принципов IaaC является основополагающим?

Идемпотентность - то есть неизменность результата при повторении одних и тех же действий.

## Задача 2

> - Чем Ansible выгодно отличается от других систем управление конфигурациями?

Ansible не использует агентов для конфигурирования целевой среды, вместо этого используется существующая SSH-инфраструктура. Достаточно на целевой машине организовать SSH-доступ и разместить SSh-ключи управляющей машины с Ansible.

> - Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

Считаю метод `push` более надёжным, так как в случае с `pull` мы имеем единую точку отказа в виде сервера хранения конфигураций. То есть агенты целевой среды не смогут получить обновления конфигурации.

В случае с `push`-методом мы можем конфигурировать из любого места, главное быть внутри SSH-инфраструктуры.

## Задача 3

Установить на личный компьютер:

> - VirtualBox

```bash
 /tmp ❯ VBoxManage --version
6.1.32_SUSEr149290
```

> - Vagrant

```bash
 /tmp ❯ vagrant --version
Vagrant 2.2.19
```

> - Ansible

```bash
 /tmp ❯ ansible --version
ansible 2.9.27
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/shtepa/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.8/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.13 (default, Mar 26 2022, 22:17:55) [GCC]
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

---

```bash
 ~/w/n/d/s/0/0/vagrant ❯ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
==> server1.netology: Matching MAC address for NAT networking...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> server1.netology: There was a problem while downloading the metadata for your box
==> server1.netology: to check for updates. This is not an error, since it is usually due
==> server1.netology: to temporary network problems. This is just a warning. The problem
==> server1.netology: encountered was:
==> server1.netology: 
==> server1.netology: The requested URL returned error: 404
==> server1.netology: 
==> server1.netology: If you want to check for box updates, verify your network connection
==> server1.netology: is valid and try again.
==> server1.netology: Setting the name of the VM: server1.netology
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: 
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology: 
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/shtepa/workbench/netology.ru/devops-netology/sysadm-homeworks/05-virt/02-iaac/vagrant
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=1   

 ~/w/n/d/s/0/0/vagrant ❯ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 29 Apr 2022 03:26:48 PM UTC

  System load:  0.64               Users logged in:          0
  Usage of /:   13.5% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 24%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.11
  Processes:    117


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Fri Apr 29 15:26:31 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ docker images
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
vagrant@server1:~$ docker --version
Docker version 20.10.14, build a224086
vagrant@server1:~$ 
```
