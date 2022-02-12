# Домашнее задание к занятию «2.4. Инструменты Git»

Данные репозитория [Terraform](https://github.com/hashicorp/terraform):

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.

```shell
 /t/terraform ❯ git show --format="%H%n%s" --no-patch aefea
aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Update CHANGELOG.md
```

- Хеш: `aefead2207ef7e2aa5dc81a34aedf0cad4c32545`
- Комментарий: `Update CHANGELOG.md`

2. Какому тегу соответствует коммит `85024d3`?

```shell
 /t/terraform ❯ git describe 85024d3
v0.12.23
```

- Тег: `v0.12.23`

3. Сколько родителей у коммита `b8d720`? Напишите их хеши.

```shell
 /t/terraform ❯ git show --pretty=%P b8d720
56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b
```

- Два родителя с хешами: `56cd7859e05c36c06b56d013b55a252d0bb7e158` и `9ea88f22fc6269854151c571162c5bcf958bee2b`

4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами **v0.12.23** и **v0.12.24**.

```shell
 /t/terraform ❯ git log --format='%H "%s"' v0.12.23..v0.12.24^
b14b74c4939dcab573326f4e3ee2a62e23e12f89 "[Website] vmc provider links"
3f235065b9347a758efadc92295b540ee0a5e26e "Update CHANGELOG.md"
6ae64e247b332925b872447e9ce869657281c2bf "registry: Fix panic when server is unreachable"
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 "website: Remove links to the getting started guide's old location"
06275647e2b53d97d4f0a19a0fec11f6d69820b5 "Update CHANGELOG.md"
d5f9411f5108260320064349b757f55c09bc4b80 "command: Fix bug when using terraform login on Windows"
4b6d06cc5dcb78af637bbb19c198faff37a066ed "Update CHANGELOG.md"
dd01a35078f040ca984cdd349f18d0b67e486c35 "Update CHANGELOG.md"
225466bc3e5f35baa5d07197bbc079345b77525e "Cleanup after v0.12.23 release"
```

- Перечислены коммиты строго между указанными тегами, коммиты с указанными тегами исключены.

5. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит так `func providerSource(...)` (вместо троеточего перечислены аргументы).

```shell
 /t/terraform ❯ git log --format=%H -S "func providerSource("
8c928e83589d90a031f811fae52a81be7153e82f
```

- В журнале (log) есть только одна запись содержащая строку с определение функции, значит эта запись и есть коммит её создания - `8c928e83589d90a031f811fae52a81be7153e82f`

6. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.

```shell
 /t/terraform ❯ git log --format=%H --no-patch -L:"globalPluginDirs":(git grep --name-only "func globalPluginDirs")
78b12205587fe839f10d946ea3fdc06719decb05
52dbf94834cb970b510f2fba853a5b49ad9b1a46
41ab0aef7a0fe030e84018973a64135b11abcd70
66ebff90cdfaa6938f26f908c7ebad8d547fea17
8364383c359a6b738a436d1b7745ccdce178df47
```

- Функция изменялась в коммитах: `78b12205587fe839f10d946ea3fdc06719decb05`, `52dbf94834cb970b510f2fba853a5b49ad9b1a46`, `41ab0aef7a0fe030e84018973a64135b11abcd70`, `66ebff90cdfaa6938f26f908c7ebad8d547fea17`, `8364383c359a6b738a436d1b7745ccdce178df47`.
- Для проверки результата использовалась следующая команда:

```shell
 ~/n/terraform ❯ git log -L:"globalPluginDirs":(git grep --name-only "func globalPluginDirs")
```

7. Кто автор функции `synchronizedWriters`?

```shell
 ~/n/terraform ❯ git log --format=%an -S"func synchronizedWriters(" --reverse | head -n 1
Martin Atkins
```

- Автор функции **Martin Atkins**. Команды находят все коммиты с функцией `synchronizedWriters`, переворачивают список и берут первую запись, так как скорее всего первая запись и будет созданием функции. Гипотеза проверена визуально.

```shell
 ~/n/terraform ❯ git log --format="%H %an" -S"func synchronizedWriters("
bdfea50cc85161dea41be0fe3381fd98731ff786 James Bardin
5ac311e2a91e381e2f52234668b49ba670aa0fe5 Martin Atkins
 ~/n/terraform ❯ git show bdfea50cc85161dea41be0fe3381fd98731ff786 5ac311e2a91e381e2f52234668b49ba670aa0fe5
```
