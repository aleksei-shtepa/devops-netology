# Домашнее задание к занятию "13.3 работа с kubectl"
## Задание 1: проверить работоспособность каждого компонента
Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый компонент:
* сделайте запросы к бекенду;
* сделайте запросы к фронту;
* подключитесь к базе данных.

## Задание 2: ручное масштабирование

При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, попробуйте увеличить количество бекенда и фронта до 3. Проверьте, на каких нодах оказались копии после каждого действия (kubectl describe, kubectl get pods -o wide). После уменьшите количество копий до 1.

---

# Решение

## Подготовка

1. Для удобства работы разместил поды задания в контексте `production`. 

```shell
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl config set-context production
Context "production" created.

 ~/w/n/d/d/13-kubernetes-config ❯ kubectl config get-contexts
CURRENT   NAME          CLUSTER                               AUTHINFO                              NAMESPACE
          production                                                                                
          yc-netolog    yc-managed-k8s-cato6kovg90ecamtdsih   yc-managed-k8s-cato6kovg90ecamtdsih   
          yc-netolog2   yc-managed-k8s-catsk7ihdq92lve0bin8   yc-managed-k8s-catsk7ihdq92lve0bin8   
          yc-netolog3   yc-managed-k8s-catlcq67foag87ordet7   yc-managed-k8s-catlcq67foag87ordet7   
*         yc-netolog4   yc-managed-k8s-catprbn0fc64sbichk9s   yc-managed-k8s-catprbn0fc64sbichk9s

 ~/w/n/d/d/13-kubernetes-config ❯ kubectl config use-context production 
Switched to context "production".

 ~/w/n/d/d/13-kubernetes-config ❯ kubectl config current-context
production
```

1. В предварительно развёрнутом в Яндекс облаке кластере kubernetes развернул поды `backend`, `frontend` и `db`.

```bash
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl apply -f 03-kubctl/manifest/ -n production
deployment.apps/backend created
service/backend-svc created
statefulset.apps/db created
service/db-svc created
persistentvolumeclaim/db-pvc created
deployment.apps/frontend created
service/frontend-svc created
persistentvolume/db-pv created
```

Полученные поды из пространства имён `production`:

```console
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl get pods -o wide -n production 
NAME                       READY   STATUS    RESTARTS   AGE     IP             NODE                        NOMINATED NODE   READINESS GATES
backend-d5c95cb66-97d62    1/1     Running   0          3m27s   10.112.130.7   cl1umi92nqepnfdg22l0-ocok   <none>           <none>
db-0                       1/1     Running   0          3m27s   10.112.129.6   cl1umi92nqepnfdg22l0-ecud   <none>           <none>
frontend-875c7c5b8-h2g2p   1/1     Running   0          3m26s   10.112.130.8   cl1umi92nqepnfdg22l0-ocok   <none>           <none>
```

Созданные services:

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl get services -o wide -n production
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE     SELECTOR
backend-svc    ClusterIP   10.96.214.170   <none>        9000/TCP   7m10s   app=backend
db-svc         ClusterIP   10.96.226.121   <none>        5432/TCP   7m9s    app=db
frontend-svc   ClusterIP   10.96.203.207   <none>        8000/TCP   7m9s    app=frontend
```

<details><summary>Описание пода `frontend` ...</summary>

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl describe pods/frontend-875c7c5b8-h2g2p -n production
Name:             frontend-875c7c5b8-h2g2p
Namespace:        production
Priority:         0
Service Account:  default
Node:             cl1umi92nqepnfdg22l0-ocok/10.129.0.25
Start Time:       Fri, 24 Feb 2023 22:40:45 +0300
Labels:           app=frontend
                  pod-template-hash=875c7c5b8
Annotations:      <none>
Status:           Running
IP:               10.112.130.8
IPs:
  IP:           10.112.130.8
Controlled By:  ReplicaSet/frontend-875c7c5b8
Containers:
  frontend:
    Container ID:   containerd://a0bcd8ede81b2d8ac4fc00af251779ea38d5cc1ee6ea7398c426c38b25c4b1a7
    Image:          alekseishtepa/13-kub-config-01-frontend:latest
    Image ID:       docker.io/alekseishtepa/13-kub-config-01-frontend@sha256:f52fd102541d6c62198385001609822575fc37315004631ac805e6d91e04a607
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 24 Feb 2023 22:40:46 +0300
    Ready:          True
    Restart Count:  0
    Environment:
      BASE_URL:  http://backend-svc:9000
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-pjdwb (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-pjdwb:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  13m   default-scheduler  Successfully assigned production/frontend-875c7c5b8-h2g2p to cl1umi92nqepnfdg22l0-ocok
  Normal  Pulled     13m   kubelet            Container image "alekseishtepa/13-kub-config-01-frontend:latest" already present on machine
  Normal  Created    13m   kubelet            Created container frontend
  Normal  Started    13m   kubelet            Started container frontend

 ~/w/n/d/d/13-kubernetes-config ❯ kubectl describe svc frontend-svc -n production
Name:              frontend-svc
Namespace:         production
Labels:            <none>
Annotations:       <none>
Selector:          app=frontend
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.96.203.207
IPs:               10.96.203.207
Port:              frontend-port  8000/TCP
TargetPort:        80/TCP
Endpoints:         10.112.130.8:80
Session Affinity:  None
Events:            <none>
```
</details>

<details><summary>Описание пода `backend` ...</summary>

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl describe pods/backend-d5c95cb66-97d62 -n production
Name:             backend-d5c95cb66-97d62
Namespace:        production
Priority:         0
Service Account:  default
Node:             cl1umi92nqepnfdg22l0-ocok/10.129.0.25
Start Time:       Fri, 24 Feb 2023 22:40:44 +0300
Labels:           app=backend
                  pod-template-hash=d5c95cb66
Annotations:      <none>
Status:           Running
IP:               10.112.130.7
IPs:
  IP:           10.112.130.7
Controlled By:  ReplicaSet/backend-d5c95cb66
Containers:
  backend:
    Container ID:   containerd://7f62dcdc4aba32416363581c11fe86deec169367b551ddc53b834b172da897e2
    Image:          alekseishtepa/13-kub-config-01-backend:latest
    Image ID:       docker.io/alekseishtepa/13-kub-config-01-backend@sha256:67294951d190fed3fda5e2556baca9717af6980a8f3a05c9eaf2379cc8cc4228
    Port:           9000/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 24 Feb 2023 22:40:45 +0300
    Ready:          True
    Restart Count:  0
    Environment:
      DATABASE_URL:  postgresql://postgres:postgres@db-svc:5432/news
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-g572c (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-g572c:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  16m   default-scheduler  Successfully assigned production/backend-d5c95cb66-97d62 to cl1umi92nqepnfdg22l0-ocok
  Normal  Pulled     16m   kubelet            Container image "alekseishtepa/13-kub-config-01-backend:latest" already present on machine
  Normal  Created    16m   kubelet            Created container backend
  Normal  Started    16m   kubelet            Started container backend

 ~/w/n/d/d/13-kubernetes-config ❯ kubectl describe svc backend-svc -n production
Name:              backend-svc
Namespace:         production
Labels:            <none>
Annotations:       <none>
Selector:          app=backend
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.96.214.170
IPs:               10.96.214.170
Port:              backend-port  9000/TCP
TargetPort:        9000/TCP
Endpoints:         10.112.130.7:9000
Session Affinity:  None
Events:            <none>
```
</details>

## Задание 1

### Запросы к backend

Применил `exec` для доступа к `backend` из `frontend`:

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl exec frontend-875c7c5b8-h2g2p -n production -- curl -s http://backend-svc:9000/api/news/
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]
⏎
```

Для применения `port-forward` необходимо использовать два терминала. В одном активировал перенаправление...
```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl port-forward svc/backend-svc 9090:9000 -n production
Forwarding from 127.0.0.1:9090 -> 9000
Forwarding from [::1]:9090 -> 9000
Handling connection for 9090
^C⏎
 ~/w/n/d/d/13-kubernetes-config ❯   
```

... в другом терминале проверил перенаправление:

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ curl 127.1:9090/api/news/ 
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]
⏎
```

### Запросы к frontend

Применил `exec` для доступа к `frontend` из `backend`:

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl exec backend-d5c95cb66-97d62 -n production -- curl -s http://frontend-svc:8000
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>⏎
```

Для применения `port-forward` необходимо использовать два терминала. В одном активировал перенаправление...
```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl port-forward svc/frontend-svc 8080:8000 -n production
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
^C⏎
 ~/w/n/d/d/13-kubernetes-config ❯   
```

... в другом терминале проверил перенаправление:

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ curl 127.1:8080
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>⏎
```

### Подключение к базе данных

Подключился к БД из её пода:

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl exec -ti db-0 -- bash -c "psql postgresql://postgres:postgres@127.1:5432/news"
psql (13.10)
Type "help" for help.

news=# \d
             List of relations
 Schema |    Name     |   Type   |  Owner
--------+-------------+----------+----------
 public | news        | table    | postgres
 public | news_id_seq | sequence | postgres
(2 rows)

news=# \q
```

Для применения `port-forward` необходимо использовать два терминала. В одном активировал перенаправление...
```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl port-forward svc/db-svc 5432:5432 -n production
Forwarding from 127.0.0.1:5432 -> 5432
Forwarding from [::1]:5432 -> 5432
Handling connection for 5432
^C⏎
 ~/w/n/d/d/13-kubernetes-config ❯   
```

... в другом терминале проверил перенаправление:

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ podman run -ti --rm --network=host --entrypoint=/bin/bash docker.io/postgres:alpine -c "psql postgresql://postgres:postgres@127.1/news"
psql (13.10)
Type "help" for help.

news=# \d
             List of relations
 Schema |    Name     |   Type   |  Owner
--------+-------------+----------+----------
 public | news        | table    | postgres
 public | news_id_seq | sequence | postgres
(2 rows)

news=# \q
```

## Задание 2

Исходное состояние деплоя:

![scale1.png](03-kubctl/img/scale1.png "Исходное состояние деплоя")

Увеличил количество реплик для `frontend` и `backend`:

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl scale --replicas=3 deploy/frontend -n production
deployment.apps/frontend scaled
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl scale --replicas=3 deploy/backend -n production
deployment.apps/backend scaled
```

Состояние деплоя после масштабирования:

![scale3.png](03-kubctl/img/scale3.png "Состояние деплоя после масштабирования")

Описание деплоев:

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl describe deploy/backend -n production
Name:                   backend
Namespace:              production
CreationTimestamp:      Fri, 24 Feb 2023 22:40:44 +0300
Labels:                 app=backend
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=backend
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=backend
  Containers:
   backend:
    Image:      alekseishtepa/13-kub-config-01-backend:latest
    Port:       9000/TCP
    Host Port:  0/TCP
    Environment:
      DATABASE_URL:  postgresql://postgres:postgres@db-svc:5432/news
    Mounts:          <none>
  Volumes:           <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   backend-d5c95cb66 (3/3 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  7m31s  deployment-controller  Scaled up replica set backend-d5c95cb66 to 3
```

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl describe deploy/frontend -n production
Name:                   frontend
Namespace:              production
CreationTimestamp:      Fri, 24 Feb 2023 22:40:45 +0300
Labels:                 app=frontend
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=frontend
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=frontend
  Containers:
   frontend:
    Image:      alekseishtepa/13-kub-config-01-frontend:latest
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:
      BASE_URL:  http://backend-svc:9000
    Mounts:      <none>
  Volumes:       <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   frontend-875c7c5b8 (3/3 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  9m45s  deployment-controller  Scaled up replica set frontend-875c7c5b8 to 3
```

Сократил число реплик `frontend` и `backend` до 1:

```ShellSession
 ~/w/n/d/d/13-kubernetes-config ❯ kubectl scale --replicas=1 deploy/backend -n production
deployment.apps/backend scaled

 ~/w/n/d/d/13-kubernetes-config ❯ kubectl scale --replicas=1 deploy/frontend -n production
deployment.apps/frontend scaled

 ~/w/n/d/d/13-kubernetes-config ❯ kubectl get pods -o wide -n production
NAME                       READY   STATUS    RESTARTS   AGE   IP             NODE                        NOMINATED NODE   READINESS GATES
backend-d5c95cb66-97d62    1/1     Running   0          86m   10.112.130.7   cl1umi92nqepnfdg22l0-ocok   <none>           <none>
db-0                       1/1     Running   0          86m   10.112.129.6   cl1umi92nqepnfdg22l0-ecud   <none>           <none>
frontend-875c7c5b8-h2g2p   1/1     Running   0          86m   10.112.130.8   cl1umi92nqepnfdg22l0-ocok   <none>           <none>

 ~/w/n/d/d/13-kubernetes-config ❯ kubectl get deploy -o wide -n production
NAME       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                           SELECTOR
backend    1/1     1            1           86m   backend      alekseishtepa/13-kub-config-01-backend:latest    app=backend
frontend   1/1     1            1           86m   frontend     alekseishtepa/13-kub-config-01-frontend:latest   app=frontend

 ~/w/n/d/d/13-kubernetes-config ❯ kubectl describe deploy/frontend -n production
Name:                   frontend
Namespace:              production
CreationTimestamp:      Fri, 24 Feb 2023 22:40:45 +0300
Labels:                 app=frontend
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=frontend
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=frontend
  Containers:
   frontend:
    Image:      alekseishtepa/13-kub-config-01-frontend:latest
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:
      BASE_URL:  http://backend-svc:9000
    Mounts:      <none>
  Volumes:       <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   frontend-875c7c5b8 (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  13m   deployment-controller  Scaled up replica set frontend-875c7c5b8 to 3
  Normal  ScalingReplicaSet  57s   deployment-controller  Scaled down replica set frontend-875c7c5b8 to 1
 ~/w/n/d/d/13-kubernetes-config ❯ 
```

