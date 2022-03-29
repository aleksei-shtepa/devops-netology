from base64 import encode
import os
import requests

class YaUploader:
    def __init__(self, token: str):
        self.token = token

    def upload(self, file_path: str):
        """Метод загруджает файл file_path на яндекс диск"""
        headers = {'Authorization': self.token}
        params = {'path': '/' + file_path, 'overwrite': 'true'}
        r = requests.get("https://cloud-api.yandex.net:443/v1/disk/resources/upload", headers=headers, params=params)

        with open(file_path, "r") as f:
            data = f.read()
        r = requests.put(r.json()['href'], data=bytes(data, encoding="utf-8"))

        return r.status_code


if __name__ == '__main__':
    uploader = YaUploader('AQAEA7qhfDgBAADLW7PSt8R3R03lqksME2UWql4')
    result = uploader.upload('recipes.txt')
    print(result)