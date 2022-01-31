# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"

Параметры исходной системы:

```shell
~/w/n/d/s/03-sysadmin-01-terminal ❯ hostnamectl
 Static hostname: shtepa
       Icon name: computer-desktop
         Chassis: desktop
      Machine ID: e66743f7122a48e9953fd0dac372a005
         Boot ID: 16d6e54224aa4bbaaabf9b5e31369ffa
Operating System: openSUSE Tumbleweed                
     CPE OS Name: cpe:/o:opensuse:tumbleweed:20220128
          Kernel: Linux 5.16.2-1-default
    Architecture: x86-64
 Hardware Vendor: Gigabyte Technology Co., Ltd.
  Hardware Model: B450M S2H
```

1. Установите средство виртуализации Oracle VirtualBox.

    ```shell
    ~/w/n/d/s/03-sysadmin-01-terminal ❯ sudo zypper in virtualbox
    ```

2. Установите средство автоматизации Hashicorp Vagrant.

    ```shell
    ~/w/n/d/s/03-sysadmin-01-terminal ❯ sudo zypper in vagrant
    ```

3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал.

    ```yaml
    Terminal:   Tilix
    Shell:      Fish
    Coloring:   Solarized Dark
    ```

4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:

    4.1. Создал каталог для конфигурации виртуальной машины `03-sysadmin-01-terminal`.

    4.2. В каталоге `03-sysadmin-01-terminal` инициализированы конфигурационные файлы **Vagrant**:

    ```shell
    ~/w/n/d/s/03-sysadmin-01-terminal ❯ vagrant init
    ```

    4.3. Скорректировал конфигурационный файл [Vagrantfile](Vagrantfile).

    4.4. Проверил работоспособность команд запуска виртуальной машины, завершения её работы с сохранением состояния и выключения:

    ```shell
    ~/w/n/d/s/03-sysadmin-01-terminal ❯ vagrant up
    ...
    ~/w/n/d/s/03-sysadmin-01-terminal ❯ vagrant suspend
    ...
    ~/w/n/d/s/03-sysadmin-01-terminal ❯ vagrant halt
    ```

5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?

    ```yaml
    Оперативная память: 1024 МБ
    Процессоры:         2
    VT-x/AMD-V:         False
    Видео память:       4 МБ
    Носитель информации: 64 ГБ (динамически расширяемый)
    ```

6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: [документация](https://www.vagrantup.com/docs/providers/virtualbox/configuration). Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

    ```Vagrantfile
    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"

        config.vm.provider "virtualbox" do |v, override|
            v.memory = 2024
            v.cpus = 4
        end

    end
    ```

7. Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.

    ```shell
    ~/w/n/d/s/03-sysadmin-01-terminal ❯ vagrant ssh
    Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

    * Documentation:  https://help.ubuntu.com
    * Management:     https://landscape.canonical.com
    * Support:        https://ubuntu.com/advantage

    System information as of Mon 31 Jan 2022 10:01:20 AM UTC

    System load:  0.11               Processes:             144
    Usage of /:   11.9% of 30.88GB   Users logged in:       0
    Memory usage: 10%                IPv4 address for eth0: 10.0.2.15
    Swap usage:   0%


    This system is built by the Bento project by Chef Software
    More information can be found at https://github.com/chef/bento
    Last login: Mon Jan 31 09:52:38 2022 from 10.0.2.2
    vagrant@vagrant:~$ 
    ```

8. Ознакомиться с разделами man bash, почитать о настройках самого bash:

    - какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?

        - Длина журнала комманд history определяется преременной `HISTSIZE` (Manual page bash(1) line 802, раздел `HISTSIZE`);

    - что делает директива ignoreboth в bash?

        - Директива `ignoreboth` - это сокращение от комбинации двух директив `ignorespace` (не включать в историю команд те, что начинаются с пробела) и `ignoredups` (не добавлять в историю команд те, которые уже присутствуют в истории).

9. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?

    - Расширение скобок (`Manual page bash(1) line 1014`, раздел `Brace Expansion`) - это механизм формирования строк. Позволяет передавать в команды строку параметров сформированных по шаблону.

10. С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?

    ```shell
    ~/w/n/d/s/03-sysadmin-01-terminal ❯ touch {1..100000}
    ```

    - В документации (`Manual page bash(1) line 933`, раздел `Array`) сказано об отсутствие верхних пределов у массивов, а формируемые фигурными скобками строки представляют собой массив. В нашем случае мы пытаемся сформировать для команды `touch` строку параметров с 300000 элементов и получаем ошибку о слишком длинной строке (это ограничение операционной системы):

    ```shell
    vagrant@vagrant:~/test$ touch {1..300000}
    -bash: /usr/bin/touch: Argument list too long
    ```

11. В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]

    - Конструкция `[[ -d /tmp ]]` возвращает 0 (Истина) если файл `/tmp` существует и это каталог. Используется в условных конструкциях.

12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:

    ```shell
    vagrant@vagrant:~$ mkdir /tmp/new_path_directory
    vagrant@vagrant:~$ cd /tmp/new_path_directory/
    vagrant@vagrant:/tmp/new_path_directory$ ln -s /bin/bash ./bash
    vagrant@vagrant:/tmp/new_path_directory$ PATH=$(pwd):$PATH
    vagrant@vagrant:/tmp/new_path_directory$ type -a bash
    bash is /tmp/new_path_directory/bash
    bash is /usr/bin/bash
    bash is /bin/bash
    ```

13. Чем отличается планирование команд с помощью batch и at?

    - `batch` и `at` используются для назначения одноразового задания, `at` в назначенное время, `batch` - при падении среднего значения нагрузки ниже установленного уровня.

14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.

    ```shell
    ~/w/n/d/s/03-sysadmin-01-terminal ❯ vagrant halt
    ```
