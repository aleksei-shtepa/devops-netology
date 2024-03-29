# Домашнее задание к занятию "10.01. Зачем и что нужно мониторить"

## Обязательные задания

1. *Вас пригласили настроить мониторинг на проект. На онбординге вам рассказали, что проект представляет из себя 
платформу для вычислений с выдачей текстовых отчетов, которые сохраняются на диск. Взаимодействие с платформой 
осуществляется по протоколу http. Также вам отметили, что вычисления загружают ЦПУ. Какой минимальный набор метрик вы
выведите в мониторинг и почему?*

    1. Мониторинг использования процессорного времени (CPU):
        - общая относительная нагрузка на машину (с учётом многопроцессорности или многоядерности, `uptime`) - поможет определиться с достаточностью выделенных ресурсов и необходимостью их расширения;
        - загрузка (утилизация) каждого ядря/процессора - для оптимизации используемых ресурсов. Либо разработчики могут более широко использовать аппаратные возможности, либо увеличить количество запущенных экземпляров на одной машине;
        - рейтинг процессов больше всего нагружающих CPU - для выявления аномалий, когда в рейтинг попадают процессы, которых там не должно быть;
    1. Мониторинг оперативной памяти (RAM):
        - процент использования оперативной памяти машины с учётом и без кэширования - позволяет контролировать выделенные машине ресурсы;
        - рейтинг процессов больше всего потребляющих оперативную память - позволит определить отклонения в работе платформы, например, "утечки памяти";
    1. Мониторинг носителя информации (HDD, SSD, сетевое хранилище):
        - процент используемого пространства и скорость его израсходования - для своевременного расширения носителя и предотвращения блокировки платформы при его исчерпании;
        - скорость записи данных на носитель - для мониторинга деградации носителя информации и своевременной его замены;
    1. Мониторинг сетевой активности:
        - процент использования сетевого канала - позволит выявить момент, когда сетевой канал станет "узким местом" платформы;
        - количество запросов к платформе и коды возврата - ранжирование кодов возврата на положитеьные и отрицательные позволит расчитать SLI;
        - доступность платформы из вне - метрика необходима для реализации оповещения о сбоях и расчёта SLI;
    
    Так же к платфоре можно подключить систему хранения логов и трассировку ошибок, что позволит разработчикам получить дополнительную информацию при сбоях в промышленной среде.

2. *Менеджер продукта посмотрев на ваши метрики сказал, что ему непонятно что такое RAM/inodes/CPUla. Также он сказал, 
что хочет понимать, насколько мы выполняем свои обязанности перед клиентами и какое качество обслуживания. Что вы 
можете ему предложить?*

    Первым делом намекнуть менеджеру продукта, что ему необходимо подучиться, повысить свою компетентность &#128518;

    А если серьёзно, то для него будут более понятны метрики показывающие соотношение между общим количеством запросов клиентов к платформе и реакциями платформы на эти запросы:

    - недоступность платформы для клиента - соотношение между общим временем работы платформы и временем доступности;
    - качество работы платформы - соотношение между общим количеством запросов и количеством "успешных" ответов;
    
    Так же не мало важным будет метрика скорости ответа на запрос клиентов.

3. *Вашей DevOps команде в этом году не выделили финансирование на построение системы сбора логов. Разработчики в свою 
очередь хотят видеть все ошибки, которые выдают их приложения. Какое решение вы можете предпринять в этой ситуации, 
чтобы разработчики получали ошибки приложения?*

    Можно использовать машины разработчиком для разворачивания одного из open source решений по сбору логов.

    Или более лучшим решением будет использовании облачных систем сборов логов с бесплатными тарифами. Например, [Sentry](https://sentry.io), [Logentries](https://logentries.com/), [Yandex Cloud Logging](https://cloud.yandex.ru/services/logging) и т.п.

3. *Вы, как опытный SRE, сделали мониторинг, куда вывели отображения выполнения SLA=99% по http кодам ответов. 
Вычисляете этот параметр по следующей формуле: summ_2xx_requests/summ_all_requests. Данный параметр не поднимается выше 
70%, но при этом в вашей системе нет кодов ответа 5xx и 4xx. Где у вас ошибка?*

    Наверняка в системе используются коды перенаправлений для перемещённых ресурсов - 3xx. Следовательно формула должна быть вида:

    ```
    SLA = (summ_2xx_requests + summ_3xx_requests) / summ_all_requests
    ```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Вы устроились на работу в стартап. На данный момент у вас нет возможности развернуть полноценную систему 
мониторинга, и вы решили самостоятельно написать простой python3-скрипт для сбора основных метрик сервера. Вы, как 
опытный системный-администратор, знаете, что системная информация сервера лежит в директории `/proc`. 
Также, вы знаете, что в системе Linux есть  планировщик задач cron, который может запускать задачи по расписанию.

Суммировав все, вы спроектировали приложение, которое:
- является python3 скриптом
- собирает метрики из папки `/proc`
- складывает метрики в файл 'YY-MM-DD-awesome-monitoring.log' в директорию /var/log 
(YY - год, MM - месяц, DD - день)
- каждый сбор метрик складывается в виде json-строки, в виде:
  + timestamp (временная метка, int, unixtimestamp)
  + metric_1 (метрика 1)
  + metric_2 (метрика 2)
  
     ...
     
  + metric_N (метрика N)
  
- сбор метрик происходит каждую 1 минуту по cron-расписанию

Для успешного выполнения задания нужно привести:

а) работающий код python3-скрипта,

б) конфигурацию cron-расписания,

в) пример верно сформированного 'YY-MM-DD-awesome-monitoring.log', имеющий не менее 5 записей,

P.S.: количество собираемых метрик должно быть не менее 4-х.  
P.P.S.: по желанию можно себя не ограничивать только сбором метрик из `/proc`.

---

Скрипт сбора метрик [monitor.py](./01-base/monitor.py) собирает данные:

- о средней загрузке центрального процессора;
- о количестве активных ядер процессора;
- о средней загрузке хоста (сейчас, за 5 минут, за 15 минут);
- об общем числе процессов и количестве активных сейчас;
- о состоянии оперативной памяти.

Скрипт поставлен в задачу для `cron`:

```
MAILTO=""
* * * * * /bin/python3 /home/shtepa/bin/monitor.py
```

<details>
<summary>Часть лога скрипта мониторирования</summary>

```json
{"timestamp": 1663245541, "host_avg_load": {"t1": "0.10", "t5": "0.18", "t15": "0.22", "process_deque": "1", "process_all": "1799"}, "nproc": 12, "ram": {"total": "16318420", "free": "773188", "available": "9942648"}, "cpu_avg_load": 1}
{"timestamp": 1663245601, "host_avg_load": {"t1": "0.61", "t5": "0.29", "t15": "0.26", "process_deque": "2", "process_all": "1824"}, "nproc": 12, "ram": {"total": "16318420", "free": "214880", "available": "9568848"}, "cpu_avg_load": 8}
{"timestamp": 1663245661, "host_avg_load": {"t1": "0.37", "t5": "0.28", "t15": "0.26", "process_deque": "1", "process_all": "1817"}, "nproc": 12, "ram": {"total": "16318420", "free": "848424", "available": "10110900"}, "cpu_avg_load": 1}
{"timestamp": 1663245722, "host_avg_load": {"t1": "0.53", "t5": "0.34", "t15": "0.28", "process_deque": "3", "process_all": "1812"}, "nproc": 12, "ram": {"total": "16318420", "free": "581988", "available": "9963692"}, "cpu_avg_load": 10}
{"timestamp": 1663245781, "host_avg_load": {"t1": "0.89", "t5": "0.49", "t15": "0.34", "process_deque": "2", "process_all": "1806"}, "nproc": 12, "ram": {"total": "16318420", "free": "228416", "available": "9803532"}, "cpu_avg_load": 9}
{"timestamp": 1663245841, "host_avg_load": {"t1": "1.11", "t5": "0.63", "t15": "0.40", "process_deque": "2", "process_all": "1805"}, "nproc": 12, "ram": {"total": "16318420", "free": "219988", "available": "9625528"}, "cpu_avg_load": 11}
{"timestamp": 1663245901, "host_avg_load": {"t1": "1.19", "t5": "0.73", "t15": "0.45", "process_deque": "2", "process_all": "1799"}, "nproc": 12, "ram": {"total": "16318420", "free": "221088", "available": "9458336"}, "cpu_avg_load": 8}
{"timestamp": 1663245961, "host_avg_load": {"t1": "1.07", "t5": "0.78", "t15": "0.49", "process_deque": "2", "process_all": "1798"}, "nproc": 12, "ram": {"total": "16318420", "free": "218232", "available": "9305692"}, "cpu_avg_load": 8}
{"timestamp": 1663246021, "host_avg_load": {"t1": "1.14", "t5": "0.86", "t15": "0.53", "process_deque": "2", "process_all": "1840"}, "nproc": 12, "ram": {"total": "16318420", "free": "200560", "available": "8875212"}, "cpu_avg_load": 13}
{"timestamp": 1663246082, "host_avg_load": {"t1": "1.05", "t5": "0.88", "t15": "0.56", "process_deque": "2", "process_all": "1810"}, "nproc": 12, "ram": {"total": "16318420", "free": "204780", "available": "8963884"}, "cpu_avg_load": 10}
{"timestamp": 1663246141, "host_avg_load": {"t1": "1.54", "t5": "1.06", "t15": "0.65", "process_deque": "2", "process_all": "1810"}, "nproc": 12, "ram": {"total": "16318420", "free": "205136", "available": "8819424"}, "cpu_avg_load": 11}
{"timestamp": 1663246201, "host_avg_load": {"t1": "1.26", "t5": "1.06", "t15": "0.67", "process_deque": "2", "process_all": "1823"}, "nproc": 12, "ram": {"total": "16318420", "free": "215816", "available": "8643224"}, "cpu_avg_load": 9}
{"timestamp": 1663246261, "host_avg_load": {"t1": "1.13", "t5": "1.06", "t15": "0.70", "process_deque": "2", "process_all": "1809"}, "nproc": 12, "ram": {"total": "16318420", "free": "215132", "available": "8481568"}, "cpu_avg_load": 9}
{"timestamp": 1663246321, "host_avg_load": {"t1": "1.20", "t5": "1.09", "t15": "0.74", "process_deque": "2", "process_all": "1810"}, "nproc": 12, "ram": {"total": "16318420", "free": "233252", "available": "8327492"}, "cpu_avg_load": 8}
{"timestamp": 1663246381, "host_avg_load": {"t1": "1.50", "t5": "1.20", "t15": "0.80", "process_deque": "2", "process_all": "1827"}, "nproc": 12, "ram": {"total": "16318420", "free": "265728", "available": "8133956"}, "cpu_avg_load": 10}
{"timestamp": 1663246442, "host_avg_load": {"t1": "1.32", "t5": "1.20", "t15": "0.83", "process_deque": "2", "process_all": "1832"}, "nproc": 12, "ram": {"total": "16318420", "free": "232008", "available": "7921892"}, "cpu_avg_load": 10}
{"timestamp": 1663246501, "host_avg_load": {"t1": "1.67", "t5": "1.33", "t15": "0.90", "process_deque": "3", "process_all": "1840"}, "nproc": 12, "ram": {"total": "16318420", "free": "234156", "available": "7747476"}, "cpu_avg_load": 9}
{"timestamp": 1663246561, "host_avg_load": {"t1": "1.25", "t5": "1.27", "t15": "0.91", "process_deque": "2", "process_all": "1798"}, "nproc": 12, "ram": {"total": "16318420", "free": "306892", "available": "7695948"}, "cpu_avg_load": 9}
{"timestamp": 1663246621, "host_avg_load": {"t1": "1.25", "t5": "1.25", "t15": "0.93", "process_deque": "2", "process_all": "1811"}, "nproc": 12, "ram": {"total": "16318420", "free": "227084", "available": "7429104"}, "cpu_avg_load": 12}
{"timestamp": 1663246681, "host_avg_load": {"t1": "1.25", "t5": "1.25", "t15": "0.95", "process_deque": "3", "process_all": "1839"}, "nproc": 12, "ram": {"total": "16318420", "free": "272704", "available": "7256420"}, "cpu_avg_load": 10}
{"timestamp": 1663246741, "host_avg_load": {"t1": "1.24", "t5": "1.25", "t15": "0.97", "process_deque": "2", "process_all": "1827"}, "nproc": 12, "ram": {"total": "16318420", "free": "243812", "available": "7078912"}, "cpu_avg_load": 9}
{"timestamp": 1663246802, "host_avg_load": {"t1": "1.12", "t5": "1.22", "t15": "0.98", "process_deque": "3", "process_all": "1821"}, "nproc": 12, "ram": {"total": "16318420", "free": "214232", "available": "6956840"}, "cpu_avg_load": 14}
```

</details>
