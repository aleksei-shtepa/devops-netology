# Vector role

Ansible роль для Vector.

## Role Variables

Поддерживаются:

- vecrot_version - требуемая версия продукта

```yaml
vecrot_version: "0.23.0"
```

- config_clickhouse_host - IP-адрес БД Clickhouse

```yaml
config_clickhouse_host: "127.0.0.1"
```

## Example Playbook

```yaml
- name: Install Vector
  tags: vector
  hosts: vector
  become: true
  vars:
    config_clickhouse_host: hostvars['clickhouse-01']['ansible_host']
  roles:
    - vector_role
```

## License

MIT

## Author Information

Aleksei SHtepa
