
# Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."

## Задача 1

> Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

Задача виртуализации максимально утилизировать вычислительные мощности оборудования путём размещения на нём ряда изолированных программных сред.

Каждая такая изолированная программная среда - виртуальная машина, обеспечивается виртуальными устройствами ввода-вывода.

Виртуализация аппаратных ресурсов, устройств ввода-вывода, и разграничение их между виртуальными машинами реализуется гипервизором.

Вариант реализации гипервизора влияет на тип виртуализации:

- Аппаратная виртуализация - максимально сокращено количество абстракций между аппаратными ресурсами и виртуальной машиной. По сути, гипервизор аппаратной виртуализации сам является операционной системой. В качестве гостевой операционной системы может быть почти любая, так как нет необходимости в модицикации ядра.
- Паравиртуализация - в этом варианте гипервизор реализуется как программа (приложение) для операционной системы вычислительной машины. В качестве гостевой операционной системы могут быть только те, у которых модифицировано ядро, так как взаимодействие происходит через специальный интерфейс гипервизора.
- Виртуализация на основе ОС - функции гипервизора берёт на себя операционная система, то есть средства изоляции программных сред встроены в ядро операционной системы вычислительной машины.

## Задача 2

> Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.
>
> Организация серверов:
>
> - физические сервера,
> - паравиртуализация,
> - виртуализация уровня ОС.
>
> Условия использования:
>
> - Высоконагруженная база данных, чувствительная к отказу.
> - Различные web-приложения.
> - Windows системы для использования бухгалтерским отделом.
> - Системы, выполняющие высокопроизводительные расчеты на GPU.
>
> Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

**Высоконагруженная база данных, чувствительная к отказу.** Всё субъективно, зависит от большого количества факторов. Один из основных - резервирование (одна реплика или более, может кластер). В данный момент я выбрал для такого варианта размещение базы данных в "облаках" на базе контейнеров - виртуализация уровня ОС. По сути, можно использовать любой из предложенных вариантов организации серверов и виртуализации, главное это должны быть несколько физических машин. Конкретный выбор будет зависеть от возможностей обслуживающего персонала.

**Различные web-приложения.** WEB-приложения обладают хорошей масштабируемостью. Виртуализация на уровне ОС позволит более эффективно управлять количеством требуемых экземпляров web-приложения.

**Windows системы для использования бухгалтерским отделом.** Для такой задачи подойдёт паравиртуализация. Бухгалтерские приложения не создают постоянной повышенной нагрузки, но требуется особого внимания к безопасности обрабатываемых данных. Повышение уровня безопасности может потребовать переход на аппаратную виртуализацию, а в особых случаях и на физические сервера.

**Системы, выполняющие высокопроизводительные расчеты на GPU.** Все работы с GPU весьма ресурсоёмкие, каждый дополнительный слой абстракции будет отбирать производительность. Для таких задач лучше выбрать физические сервера.

## Задача 3

> Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.
>
> Сценарии:
>
> 1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.

Для решения данной задачи подойдёт VMWare vSphere или Microsoft Hyper-V, так как эти решения уже имеют в своём составе инструменты для репликации данных и автоматизированного механизма создания резервных копий.

> 2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.

Для данной задачи подойдёт как аппаратная виртуализация гипервизором XEN, так и паравиртуализация KVM.

> 3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.

Решения одного производителя будут более совместимы, поэтому для Windows инфраструктуры лучше подойдёт Hyper-V. В некоторых случаях можно использовать VMWare ESXi.

> 4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

Для тестирования  программных продуктов на нескольких дистрибутивах Linux, особенно если ядро ОС может отличаться, лучше использовать паравиртуализацию. В этом случае аппаратная виртуализация избыточна, а виртуализация уровня ОС использует для виртуальной машины ядро хоста. Для решения задачи можно использовать KVM, VirtualBox, VMWare Workstation Player.

## Задача 4

> Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

На мой взгляд поддержка гетерогенной среды виртуализации (предприятия в целом) требует более высокой квалификации обслуживающего персонала, более обширных знаний. Разные среды виртуализации часто имеют несовместимые форматы хранения данных и протоколы взаимодействия между системами.

Увеличивая вариативность среды мы повышаем риски выхода системы из строя, снижаем отказоустойчивость. Желательно применение на предприятии ограниченного набора инструментов виртуализации с отработанными механизмами восстановления после сбоев.

Что касаемо применения нескольких систем управления виртуализацией одновременно на одних аппаратных ресурсах, то это не всегда возможно. Мы столкнёмся с конфликтами драйверов виртуальных устройств гипервизоров.

Единственный вариант когда можно использовать гетерогенную среду виртуализации на одном аппаратном обеспечении - это использование виртуализации уровня ОС, которая в свою очередь запущена как виртуальная машина. Например, железный сервер - операционная система хоста - гипервизор паравиртуализации - виртуальная машина - операционная система гостя - контейнер. Это запуск приложения в контейнере на безе облачной инфраструктуры.
