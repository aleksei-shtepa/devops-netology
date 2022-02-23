# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

    ---

    * Linux:

        ```bash
        vagrant@vagrant:~$ ip -c -br link
        lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
        eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
        ```

    * Apple macOS:

        ```bash
         ~ ❯ networksetup -listallhardwareports

        Hardware Port: Wi-Fi
        Device: en0
        Ethernet Address: 70:56:81:b6:e2:9b

        Hardware Port: Bluetooth PAN
        Device: en2
        Ethernet Address: 70:56:81:b6:e2:9c

        Hardware Port: Thunderbolt 1
        Device: en1
        Ethernet Address: 82:0d:6b:75:ce:80

        Hardware Port: Thunderbolt Bridge
        Device: bridge0
        Ethernet Address: 82:0d:6b:75:ce:80

        VLAN Configurations
        ===================
        ```

    * Microsoft Windows:

        ```bash
        PS C:\Users\acer> ipconfig /all

        Настройка протокола IP для Windows

        Имя компьютера  . . . . . . . . . : Acer-5820TG
        Основной DNS-суффикс  . . . . . . :
        Тип узла. . . . . . . . . . . . . : Гибридный
        IP-маршрутизация включена . . . . : Нет
        WINS-прокси включен . . . . . . . : Нет
        Порядок просмотра суффиксов DNS . : home

        Адаптер Ethernet Ethernet:

        Состояние среды. . . . . . . . : Среда передачи недоступна.
        DNS-суффикс подключения . . . . . :
        Описание. . . . . . . . . . . . . : Qualcomm Atheros AR8151 PCI-E Gigabit Ethernet Controller (NDIS 6.30)
        Физический адрес. . . . . . . . . : 60-EB-69-60-3B-AA
        DHCP включен. . . . . . . . . . . : Да
        Автонастройка включена. . . . . . : Да

        Адаптер беспроводной локальной сети Подключение по локальной сети* 2:

        Состояние среды. . . . . . . . : Среда передачи недоступна.
        DNS-суффикс подключения . . . . . :
        Описание. . . . . . . . . . . . . : Microsoft Wi-Fi Direct Virtual Adapter
        Физический адрес. . . . . . . . . : 52-3E-AA-D1-E6-0E
        DHCP включен. . . . . . . . . . . : Да
        Автонастройка включена. . . . . . : Да

        Адаптер беспроводной локальной сети Беспроводная сеть 2:

        DNS-суффикс подключения . . . . . : home
        Описание. . . . . . . . . . . . . : TP-Link Wireless USB Adapter
        Физический адрес. . . . . . . . . : 50-3E-AA-D1-E4-0E
        DHCP включен. . . . . . . . . . . : Да
        Автонастройка включена. . . . . . : Да
        IPv6-адрес. . . . . . . . . . . . : fd88:e3ab:7370:3600:523e:aaff:fed1:e40e(Основной)
        Локальный IPv6-адрес канала . . . : fe80::523e:aaff:fed1:e40e%12(Основной)
        IPv4-адрес. . . . . . . . . . . . : 192.168.3.4(Основной)
        Маска подсети . . . . . . . . . . : 255.255.255.0
        Аренда получена. . . . . . . . . . : 23 февраля 2022 г. 17:17:05
        Срок аренды истекает. . . . . . . . . . : 24 февраля 2022 г. 17:17:05
        Основной шлюз. . . . . . . . . : 192.168.3.1
        DHCP-сервер. . . . . . . . . . . : 192.168.3.1
        IAID DHCPv6 . . . . . . . . . . . : 55590570
        DUID клиента DHCPv6 . . . . . . . : 00-01-00-01-24-17-2B-72-60-EB-69-60-3B-AA
        DNS-серверы. . . . . . . . . . . : 192.168.3.1
                                            192.168.3.1
        NetBios через TCP/IP. . . . . . . . : Включен
        ```

    ---

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

    ---

    * **Link Layer Discovery Protocol** (**LLDP**) — протокол канального уровня, позволяющий сетевому оборудованию оповещать оборудование, работающее в локальной сети, о своём существовании и передавать ему свои характеристики, а также получать от него аналогичные сведения.

    * Для работы с протоколом LLDP неоходимо установить пакет **lldpd**.

    * Команда `lldpctl` позволяет получить сведения об оборудовании в сети.

        ```bash
        [root@stand micard]# yum install lldpd
        ...
        [root@stand micard]# systemctl enable --now lldpd
        ...
        [root@stand micard]# lldpctl
        ----------------------------------------------------------------
        LLDP neighbors:
        ----------------------------------------------------------------
        Interface:    wlp6s0, via: LLDP, RID: 1, Time: 0 day, 00:09:53
        Chassis:     
            ChassisID:    mac b4:2e:99:8d:c5:35
            SysName:      shtepa
            SysDescr:     openSUSE Tumbleweed Linux 5.16.8-1-default #1 SMP PREEMPT Thu Feb 10 11:31:59 UTC 2022 (5d1f5d2) x86_64
            MgmtIP:       192.168.1.59
            MgmtIP:       fe80::806f:dab8:7e2f:d38c
            Capability:   Bridge, off
            Capability:   Router, off
            Capability:   Wlan, on
            Capability:   Station, off
        Port:        
            PortID:       mac d0:ab:d5:19:65:c2
            PortDescr:    wlp7s0
            TTL:          120
        LLDP-MED:    
            Device Type:  Generic Endpoint (Class I)
            Capability:   Capabilities, yes
            Capability:   Policy, yes
            Capability:   Location, yes
            Capability:   MDI/PSE, yes
            Capability:   MDI/PD, yes
            Capability:   Inventory, yes
            Inventory:   
            Hardware Revision: Default string
            Software Revision: 5.16.8-1-default
            Firmware Revision: F51
            Serial Number: Default string
            Manufacturer: Gigabyte Technology Co., Ltd.
            Model:        B450M S2H
            Asset ID:     Default string
        ----------------------------------------------------------------
        ```

    ---

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

    ---

    * Для разделения L2 коммутатора на несколько виртуальных сетей используется **Virtual Local Area Network** (**VLAN**) — технология виртуальных локальных сетей.

    * Для управление VLAN необходим пакет `vlan`. Настройка осуществляется командой `vconfig`, командой `ip link` или через файл инициализации сети `/etc/network/interfaces`.

        ```bash
        vagrant@vagrant:~$ sudo apt install vlan
        vagrant@vagrant:~$ sudo su -c 'echo "8021q" >> /etc/modules'
        ...
        vagrant@vagrant:~$ sudo vconfig add eth0 1069

        Warning: vconfig is deprecated and might be removed in the future, please migrate to ip(route2) as soon as possible!

        vagrant@vagrant:~$ sudo ip link add link eth0 name vlan1070 type vlan id 1070
        vagrant@vagrant:~$ ip a
        1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
            link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
            inet 127.0.0.1/8 scope host lo
            valid_lft forever preferred_lft forever
            inet6 ::1/128 scope host 
            valid_lft forever preferred_lft forever
        2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
            link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
            inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
            valid_lft 86344sec preferred_lft 86344sec
            inet6 fe80::a00:27ff:feb1:285d/64 scope link 
            valid_lft forever preferred_lft forever
        3: eth0.1071@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
            link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
            inet 10.10.10.1/24 brd 10.10.10.255 scope global eth0.1071
            valid_lft forever preferred_lft forever
            inet6 fe80::a00:27ff:feb1:285d/64 scope link 
            valid_lft forever preferred_lft forever
        4: eth0.1069@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
            link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
        5: vlan1070@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
            link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
        ```

        ```bash
        vagrant@vagrant:~$ cat /etc/network/interfaces
        # The loopback network interface
        auto lo
        iface lo inet loopback

        # The primary network interface
        allow-hotplug eth0
        iface eth0 inet dhcp

        auto eth0.1071
        iface eth0.1071 inet static
                address 10.10.10.1
                netmask 255.255.255.0
                network 10.10.10.0
                broadcast 10.10.10.255
                vlan-raw-device eth0
        ```

    ---

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

    ---

    **Bonding** – это объединение сетевых интерфейсов по определенному типу агрегации, Служит для увеличения пропускной способности и/или отказоустойчивость сети.

    Типы агрегации интерфейсов в Linux:

    **Mode-0(balance-rr)** – Данный режим используется по умолчанию. Balance-rr обеспечивается балансировку нагрузки и отказоустойчивость. В данном режиме сетевые пакеты отправляются “по кругу”, от первого интерфейса к последнему. Если выходят из строя интерфейсы, пакеты отправляются на остальные оставшиеся. Дополнительной настройки коммутатора не требуется при нахождении портов в одном коммутаторе. При разностных коммутаторах требуется дополнительная настройка.

    **Mode-1(active-backup)** – Один из интерфейсов работает в активном режиме, остальные в ожидающем. При обнаружении проблемы на активном интерфейсе производится переключение на ожидающий интерфейс. Не требуется поддержки от коммутатора.

    **Mode-2(balance-xor)** – Передача пакетов распределяется по типу входящего и исходящего трафика по формуле `((MAC src) XOR (MAC dest)) % число интерфейсов`. Режим дает балансировку нагрузки и отказоустойчивость. Не требуется дополнительной настройки коммутатора/коммутаторов.

    **Mode-3(broadcast)** – Происходит передача во все объединенные интерфейсы, тем самым обеспечивая отказоустойчивость. Рекомендуется только для использования MULTICAST трафика.

    **Mode-4(802.3ad)** – динамическое объединение одинаковых портов. В данном режиме можно значительно увеличить пропускную способность входящего так и исходящего трафика. Для данного режима необходима поддержка и настройка коммутатора/коммутаторов.

    **Mode-5(balance-tlb)** – Адаптивная балансировки нагрузки трафика. Входящий трафик получается только активным интерфейсом, исходящий распределяется в зависимости от текущей загрузки канала каждого интерфейса. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.

    **Mode-6(balance-alb)** – Адаптивная балансировка нагрузки. Отличается более совершенным алгоритмом балансировки нагрузки чем Mode-5). Обеспечивается балансировку нагрузки как исходящего так и входящего трафика. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.

        ```bash
        vagrant@vagrant:~$ sudo su -c 'echo "bonding" >> /etc/modules'
        vagrant@vagrant:~$ sudo modprobe bonding
        vagrant@vagrant:~$ sudo apt-get install ifenslave
        ...
        vagrant@vagrant:~$ sudo systemctl stop networking
        vagrant@vagrant:~$ sudo vim /etc/network/interfaces
        vagrant@vagrant:~$ cat /etc/network/interfaces
        # interfaces(5) file used by ifup(8) and ifdown(8)
        # Include files from /etc/network/interfaces.d:
        #source-directory /etc/network/interfaces.d

        auto bond0

        iface bond0 inet static
            address 10.0.2.50
            netmask 255.255.255.0
            network 10.0.2.0
            gateway 10.0.2.254
            bond-slaves eth0 eth1
            bond-mode active-backup
            bond-miimon 100
            bond-downdelay 200
            bond-updelay 200

        vagrant@vagrant:~$ sudo systemctl start networking
        vagrant@vagrant:~$ ip -c link
        1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
            link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
            link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
        3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
            link/ether 08:00:27:9e:82:9b brd ff:ff:ff:ff:ff:ff
        4: bond0: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
            link/ether ea:8f:be:3b:25:ca brd ff:ff:ff:ff:ff:ff
        ```

    ---

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

    ---

    * В сети с маской /29 будет 6 IP-адресов для хостов (плюс адрес подсети и широковещательный адрес).

        ```bash
        vagrant@vagrant:~$ ipcalc 0.0.0.0/29
        Address:   0.0.0.0              00000000.00000000.00000000.00000 000
        Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
        Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
        =>
        Network:   0.0.0.0/29           00000000.00000000.00000000.00000 000
        HostMin:   0.0.0.1              00000000.00000000.00000000.00000 001
        HostMax:   0.0.0.6              00000000.00000000.00000000.00000 110
        Broadcast: 0.0.0.7              00000000.00000000.00000000.00000 111
        Hosts/Net: 6                     Class A
        ```

    * В сети с маской /24 можно получить 32 подсети с маской /29. 32 = 2 в степени (29-24)

        ```bash
        vagrant@vagrant:~$ ipcalc 10.10.10.0/24 29 
        Address:   10.10.10.0           00001010.00001010.00001010. 00000000
        Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
        Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
        =>
        Network:   10.10.10.0/24        00001010.00001010.00001010. 00000000
        HostMin:   10.10.10.1           00001010.00001010.00001010. 00000001
        HostMax:   10.10.10.254         00001010.00001010.00001010. 11111110
        Broadcast: 10.10.10.255         00001010.00001010.00001010. 11111111
        Hosts/Net: 254                   Class A, Private Internet

        Subnets after transition from /24 to /29
        ...
        Network:   10.10.10.0/29        00001010.00001010.00001010.00000 000
        ...
        Network:   10.10.10.8/29        00001010.00001010.00001010.00001 000
        ...
        Network:   10.10.10.16/29       00001010.00001010.00001010.00010 000
        ...
        Network:   10.10.10.32/29       00001010.00001010.00001010.00100 000
        ...
        Network:   10.10.10.56/29       00001010.00001010.00001010.00111 000
        ...
        Subnets:   32
        Hosts:     192
        ```

    ---

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

    ---

    * Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 являются частными, по условиям задачи они заняты.

    * Есть ещё один набор частных адресов: 100.64.0.0 — 100.127.255.255 /10. Данная подсеть рекомендована согласно RFC 6598 для использования в качестве адресов для CGN (Carrier-Grade NAT).

    * Хостов предполагается около 40-50 машин, что укладывается в 6 битный адрес (2 в степени 6 = 62 хоста). Следовательно маску нужно выбрать 32-6=26.

    * Один из возможных адресов подсети для нашей задачи: **100.64.0.0/26**

    ---

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

    ---

    * ARP-таблица в Microsoft Windows:

        ```bash
        PS C:\Users\Administrator> arp -a

        Interface: 188.227.16.21 --- 0xe
          Internet Address      Physical Address      Type
          188.227.16.1          00-50-56-95-1f-6d     dynamic
          188.227.16.22         00-50-56-01-19-72     dynamic
          188.227.16.25         00-50-56-01-3f-c5     dynamic
          188.227.16.32         00-50-56-01-05-a6     dynamic
          188.227.16.255        ff-ff-ff-ff-ff-ff     static
          224.0.0.22            01-00-5e-00-00-16     static
          224.0.0.251           01-00-5e-00-00-fb     static
          224.0.0.252           01-00-5e-00-00-fc     static
          239.255.255.250       01-00-5e-7f-ff-fa     static
        ```

    * ARP-таблица в Linux:

        ```bash
        vagrant@vagrant:~$ ip -c neigh
        192.168.56.2 dev eth1 lladdr 08:00:27:4e:41:de STALE
        10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 REACHABLE
        10.0.2.3 dev eth0 lladdr 52:54:00:12:35:03 STALE
        ```

    * Очистить ARP-таблицу полностью:

        ```bash
        vagrant@vagrant:~$ sudo ip neigh flush all
        vagrant@vagrant:~$ ip -c neigh
        10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 REACHABLE
        ```

    * Удалить из ARP-таблицы выбранный IP-адрес:

        ```bash
        vagrant@vagrant:~$ sudo ip neigh del 10.0.2.3 dev eth0
        vagrant@vagrant:~$ sudo ip neigh del 192.168.56.2 dev eth1
        ```

    ---
