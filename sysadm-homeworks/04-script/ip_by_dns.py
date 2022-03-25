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
