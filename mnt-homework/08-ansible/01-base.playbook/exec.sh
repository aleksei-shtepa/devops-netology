#!/usr/bun/env bash
docker run -d --rm --name fedora36 docker.io/library/fedora:36 sleep 43200
echo "netology" > pass.tmp
ansible-playbook site.yml -i inventory/fedora.yml --vault-password-file pass.tmp
rm -f pass.tmp
docker stop fedora36
echo -e "\033[37mHave a nice day!\033[m"
