# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

## Обязательная задача 1

Мы выгрузили JSON, который получили через API запрос к нашему сервису:

```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```

  Нужно найти и исправить все ошибки, которые допускает наш сервис

**Мой вариант:**

```json
{
    "info": "Sample JSON output from our service\t",
    "elements":[
        {
            "name": "first",
            "type": "server",
            "ip":   "7175" 
        },
        {
            "name": "second",
            "type": "proxy",
            "ip":   "71.78.22.43"
        }
    ]
}
```

## Обязательная задача 2

В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

**Ваш скрипт:**

```python
#!/usr/bin/env python3
import socket
import json
import yaml
from time import sleep

url_for_watchdog = ["drive.google.com", "mail.google.com", "google.com", "cloud.micard.ru"]
url_stats = {k:socket.gethostbyname(k) for k in url_for_watchdog}

while True:
    print("--->")
    for url in url_for_watchdog:
        url_ip = socket.gethostbyname(url)
        if url_stats[url] == url_ip:
            print(f"{url} - {url_ip}")
        else:
            print(f"[ERROR] {url} IP mismatch: {url_stats[url]} {url_ip}")
        url_stats[url] = url_ip
    
    url_stats_dump = [{k:url_stats[k]} for k in url_stats]

    with open("urls.json", "w") as f_json:
        json.dump(url_stats_dump, f_json, indent=1, )

    with open("urls.yaml", "w") as f_yaml:
        yaml.dump(url_stats_dump, f_yaml, indent=1, explicit_start=True, explicit_end=True)

    try:
        sleep(3)
    except KeyboardInterrupt:
        break

```

**Вывод скрипта при запуске при тестировании:**

```bash
~/w/n/devops-netology ❯ python3 sysadm-homeworks/04-script/ip_by_dns.py
--->
drive.google.com - 173.194.222.194
mail.google.com - 173.194.222.83
google.com - 64.233.162.100
cloud.micard.ru - 5.188.115.175
--->
drive.google.com - 173.194.222.194
[ERROR] mail.google.com IP mismatch: 173.194.222.83 173.194.220.83
[ERROR] google.com IP mismatch: 64.233.162.100 74.125.131.102
cloud.micard.ru - 5.188.115.175
^C⏎
~/w/n/devops-netology ❯  
```

**json-файл(ы), который(е) записал ваш скрипт:**

```json
[
 {
  "drive.google.com": "173.194.222.194"
 },
 {
  "mail.google.com": "173.194.220.83"
 },
 {
  "google.com": "74.125.131.102"
 },
 {
  "cloud.micard.ru": "5.188.115.175"
 }
]
```

**yml-файл(ы), который(е) записал ваш скрипт:**

```yaml
---
- drive.google.com: 173.194.222.194
- mail.google.com: 173.194.220.83
- google.com: 74.125.131.102
- cloud.micard.ru: 5.188.115.175
...
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

**Ваш скрипт:**

```python
???
```

**Пример работы скрипта:**

???