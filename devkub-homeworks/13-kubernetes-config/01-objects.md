# Домашнее задание к занятию "13.1 контейнеры, поды, deployment, statefulset, services, endpoints"
Настроив кластер, подготовьте приложение к запуску в нём. Приложение стандартное: бекенд, фронтенд, база данных. Его можно найти в папке 13-kubernetes-config.

## Задание 1: подготовить тестовый конфиг для запуска приложения
Для начала следует подготовить запуск приложения в stage окружении с простыми настройками. Требования:
* под содержит в себе 2 контейнера — фронтенд, бекенд;
* регулируется с помощью deployment фронтенд и бекенд;
* база данных — через statefulset.

## Задание 2: подготовить конфиг для production окружения
Следующим шагом будет запуск приложения в production окружении. Требования сложнее:
* каждый компонент (база, бекенд, фронтенд) запускаются в своем поде, регулируются отдельными deployment’ами;
* для связи используются service (у каждого компонента свой);
* в окружении фронта прописан адрес сервиса бекенда;
* в окружении бекенда прописан адрес сервиса базы данных.

## Задание 3 (*): добавить endpoint на внешний ресурс api
Приложению потребовалось внешнее api, и для его использования лучше добавить endpoint в кластер, направленный на это api. Требования:
* добавлен endpoint до внешнего api (например, геокодер).

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, statefulset, service) или скриншот из самого Kubernetes, что сервисы подняты и работают.

---

# Решение

## Подготовка

Сборка и размещение образов в docker registry hub.docker.com для последующего использования в кластере kuberbetes.

1. В account settings - security завёл токен для доступа к registry.
1. Авторизовался в registry с помощью полученного токена
   ```
   docker login -u alekseishtepa
   ```
1. Собрал образы backend и frontend
    ```
    docker build -t alekseishtepa/13-kub-config-01-backend 01-objects/app/backend/

    docker build -t alekseishtepa/13-kub-config-01-frontend 01-objects/app/frontend/
    ```
1. Опубликовал образы в registry
    ```
    docker push alekseishtepa/13-kub-config-01-frontend:latest

    docker push alekseishtepa/13-kub-config-01-backend:latest
    ```

    ![docker_hub.png](01-objects/img/docker_hub.png "Тестовые образы опубликованы в hub.docker.com")

## Задание 1

1. Подготовил манифест для кластера kubernetes в Yandex Cloud с классом хранилища `yc-network-hdd`

    ```yaml
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: test-13-01
      name: test-13-01
      namespace: stage
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: test-13-01
      template:
        metadata:
          labels:
            app: test-13-01
        spec:
          containers:
            - name: test-13-01-frontend
              image: alekseishtepa/13-kub-config-01-frontend:latest
              imagePullPolicy: IfNotPresent
              ports:
                - name: frontend-port
                  containerPort: 80
                  protocol: TCP
            - name: test-13-01-backend
              image: alekseishtepa/13-kub-config-01-backend:latest
              imagePullPolicy: IfNotPresent
              ports:
                - name: backend-port
                  containerPort: 9000
                  protocol: TCP
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: test-13-01-srv
      namespace: stage
    spec:
      selector:
        app: test-13-01
      ports:
        - name: test-13-01-frontend-srv
          port: 8000
          targetPort: 80
          protocol: TCP
        - name: test-13-01-backend-srv
          port: 9000
          targetPort: 9000
          protocol: TCP
    ---
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
      labels:
        app: db
      name: db
      namespace: stage
    spec:
      selector:
        matchLabels:
          app: db
      serviceName: "db-srv"
      template:
        metadata:
          labels:
            app: db
        spec:
          containers:
            - name: db
              image: postgres:13-alpine
              imagePullPolicy: "IfNotPresent"
              env:
                - name: POSTGRES_USER
                  value: postgres
                - name: POSTGRES_PASSWORD
                  value: postgres
                - name: POSTGRES_DB
                  value: news
              volumeMounts:
                - name: db-volume
                  mountPath: "/var/lib/postgresql/data"
          volumes:
            - name: db-volume
              persistentVolumeClaim:
                claimName: db-pvc
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: db-srv
      namespace: stage
    spec:
      ports:
        - name: db
          port: 5432
          targetPort: 5432
          protocol: TCP
      selector:
        app: db
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: db-pvc
      namespace: stage
    spec:
      storageClassName: yc-network-hdd
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 2Gi
    ...
    ```
1. Применил конфигурацию манифеста
    ```
    kubectl apply -f 01-objects/manifest/stage.yml -n stage
    ```

    ![stage.png](01-objects/img/stage.png "Статус компонентов деплоя")

## Задание 2

1. Подготовил манифест для кластера kubernetes в Yandex Cloud с классом хранилища `yc-network-hdd`

    ```yaml
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: test-13-01-frontend
      name: test-13-01-frontend
      namespace: production
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: test-13-01-frontend
      template:
        metadata:
          labels:
            app: test-13-01-frontend
        spec:
          containers:
            - name: test-13-01-frontend
              image: alekseishtepa/13-kub-config-01-frontend:latest
              imagePullPolicy: IfNotPresent
              env:
                - name: BASE_URL
                  value: http://backend-svc:9000
              ports:
                - name: frontend-port
                  containerPort: 80
                  protocol: TCP
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: test-13-01-frontend-srv
      namespace: production
    spec:
      selector:
        app: test-13-01-frontend
      ports:
        - name: frontend-port
          port: 8000
          targetPort: 80
          protocol: TCP
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        app: test-13-01-backend
      name: test-13-01-backend
      namespace: production
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: test-13-01-backend
      template:
        metadata:
          labels:
            app: test-13-01-backend
        spec:
          containers:
            - name: test-13-01-backend
              image: alekseishtepa/13-kub-config-01-backend:latest
              imagePullPolicy: IfNotPresent
              env:
                - name: DATABASE_URL
                  value: "postgresql://postgres:postgres@db-svc:5432/news"
              ports:
                - name: backend-port
                  containerPort: 9000
                  protocol: TCP
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: test-13-01-backend-srv
      namespace: production
    spec:
      selector:
        app: test-13-01-backend
      ports:
        - name: backend-port
          port: 9000
          targetPort: 9000
          protocol: TCP
    ---
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
      labels:
        app: db
      name: db
      namespace: production
    spec:
      selector:
        matchLabels:
          app: db
      serviceName: "db"
      template:
        metadata:
          labels:
            app: db
        spec:
          containers:
            - name: db
              image: postgres:13-alpine
              imagePullPolicy: "IfNotPresent"
              env:
                - name: POSTGRES_USER
                  value: postgres
                - name: POSTGRES_PASSWORD
                  value: postgres
                - name: POSTGRES_DB
                  value: news
              volumeMounts:
                - name: db-volume
                  mountPath: "/var/lib/postgresql/data2"
          volumes:
            - name: db-volume
              persistentVolumeClaim:
                claimName: db-pvc
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: db-srv
      namespace: production
    spec:
      ports:
        - name: db
          port: 5432
          targetPort: 5432
          protocol: TCP
      selector:
        app: db
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: db-pvc
      namespace: production
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 2Gi
    ...
    ```

1. Применил конфигурацию манифеста
    ```
    kubectl apply -f 01-objects/manifest/prode.yml -n production
    ```

    ![stage.png](01-objects/img/prod.png "Статус компонентов деплоя")
