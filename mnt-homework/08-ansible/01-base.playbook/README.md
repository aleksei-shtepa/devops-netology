# Самоконтроль выполненения задания

> 1. Где расположен файл с `some_fact` из второго пункта задания?

[./group_vars/all/examp.yml](./group_vars/all/examp.yml)

> 2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?

```console
ansible-playbook site.yml -i inventory/test.yml
```

> 3. Какой командой можно зашифровать файл?

```console
ansible-vault encrypt group_vars/el/examp.yml
```

> 4. Какой командой можно расшифровать файл?

```console
ansible-vault decrypt group_vars/el/examp.yml
```

> 5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?

```console
 ~/w/n/d/m/0/01-base.playbook ❯ ansible-vault view group_vars/el/examp.yml
[DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the controller starting with Ansible 2.12. Current 
version: 3.7.13 (default, Jun 28 2022, 09:15:56) [GCC 12.1.0]. This feature will be removed from ansible-core in 
version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
Vault password: 
---
  some_fact: "el default fact"
```

> 6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?

```console
ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass 
```

> 7. Как называется модуль подключения к host на windows?

Либо `psrp` (Run tasks over Microsoft PowerShell Remoting Protocol), либо `winrm` (Run tasks over Microsoft's WinRM).

> 8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh

```console
ansible-doc -t connection ssh
```

> 9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?

Из справки:

```console
- remote_user
        User name with which to login to the remote server, normally set by the remote_user
        keyword.
        If no user is supplied, Ansible will let the ssh client binary choose the user as it
        normally
        [Default: (null)]
        set_via:
          env:
          - name: ANSIBLE_REMOTE_USER
          ini:
          - key: remote_user
            section: defaults
          vars:
          - name: ansible_user
          - name: ansible_ssh_user
        
        cli:
        - name: user
```

Пользователь для SSH-подключения определяется параметром `remote_user`. Заполнить значение параметра `remote_user` можно следующими способами:

- через значение переменной окружения `ANSIBLE_REMOTE_USER`:

```console
export ANSIBLE_REMOTE_USER=micard && ansible-playbook site.yml -i inventory/test.yml
```

- непосредственно в файле плейбука:

```yaml
---
  - name: Print os facts
    hosts: all
    remote_user: micard
    tasks:
      - name: Print OS
        debug:
          msg: "{{ ansible_distribution }}"
      - name: Print fact
        debug:
          msg: "{{ some_fact }}"
```

- через инвентари:

```yaml
---
  inside:
    hosts:
      localhost:
        ansible_connection: local
  stends:
    hosts:
      mprime:
        ansible_connection: ssh
        ansible_ssh_user: micard
        ansible_host: '192.168.1.32'
```

- через параметры запуска плейбука:

```console
ansible-playbook site.yml -i inventory/test.yml --user=micard
```