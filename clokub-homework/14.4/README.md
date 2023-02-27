# Домашнее задание к занятию "14.4 Сервис-аккаунты"

## Задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube

Вместо `minikube` использовался `Managed Service for Kubernetes` Yandex Cloud.

Для автоматизации процесса развёртывания кластера Kubernetes применены [манифесты Terraform](../terraform/) и [скрипт запуска](../plan).

```ShellSession
cd ..
./plan init
./plan apply
```

> Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
> задачу 1 как справочный материал.

### Как создать сервис-аккаунт?

```ShellSession
kubectl create serviceaccount netology
```

### Как просмотреть список сервис-акаунтов?

```ShellSession
kubectl get serviceaccounts
kubectl get serviceaccount
```

![create.png](img/create.png "Сервис-аккаунты")

### Как получить информацию в формате YAML и/или JSON?

```ShellSession
kubectl get serviceaccount netology -o yaml
kubectl get serviceaccount default -o json
```

![get.png](img/get.png "Экспорт сервис-аккаунтов")

### Как выгрузить сервис-акаунты и сохранить его в файл?

```ShellSession
kubectl get serviceaccounts -o json > serviceaccounts.json
kubectl get serviceaccount netology -o yaml > netology.yml
```

### Как удалить сервис-акаунт?

```ShellSession
kubectl delete serviceaccount netology
```

![delete.png](img/delete.png "Удаление сервис-аккаунта")

### Как загрузить сервис-акаунт из файла?

```ShellSession
kubectl apply -f netology.yml
```

![import.png](img/import.png "Создание сервис-аккаунта из манифеста")

## Задача 2 (*): Работа с сервис-акаунтами внутри модуля

Выбрать любимый образ контейнера, подключить сервис-акаунты и проверить
доступность API Kubernetes

```ShellSession
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```

Просмотреть переменные среды

```ShellSession
env | grep KUBE
```

Получить значения переменных

```ShellSession
K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
SADIR=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat $SADIR/token)
CACERT=$SADIR/ca.crt
NAMESPACE=$(cat $SADIR/namespace)
```

Подключаемся к API

```ShellSession
curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
```

В случае с minikube может быть другой адрес и порт, который можно взять здесь

```ShellSession
cat ~/.kube/config
```

или здесь

```ShellSession
kubectl cluster-info
```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, serviceaccounts) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---
