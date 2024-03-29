# Домашнее задание к занятию "11.01 Введение в микросервисы"

## Задача 1: Интернет Магазин

Руководство крупного интернет магазина у которого постоянно растёт пользовательская база и количество заказов рассматривает возможность переделки своей внутренней ИТ системы на основе микросервисов. 

Вас пригласили в качестве консультанта для оценки целесообразности перехода на микросервисную архитектуру. 

Опишите какие выгоды может получить компания от перехода на микросервисную архитектуру и какие проблемы необходимо будет решить в первую очередь.

---

### Ожидаемые преимущества

- Более короткие сроки доставки новой функциональности до конечного потребителя;
- Малая связность компонентов системы - изменение одного компонента системы мало влияет на остальные;
- Возможность масштабирования системы на уровне функциональности, вплоть до автоматизации этого процесса;
- Возможность проведения маркетинговых (или других) исследований предоставляя определённым категориям потребителей разные варианты одной и той же функциональности;
- Повышение отказоустойчивости системы в целом за счёт дублирования сервисов и управления их версиями;
- Возможность постепенного технического переоснащения системы без прерывания её функционирования.   

### Возможные сложности

- Архитектура системы должна соотноситься со структурой организации процесса разработки, структурой команд;
- Свобода выбора технологических решений при реализации микросервиса может привести к чрезмерному увеличению технологического стека компании, что приведёт к сложности подбора новых кадров и размыванию экспертизы у действующих;
- Необходимо поддерживать определённый уровень декомпозиции системы, в противном случае чрезмерное количество сервисов значительно усложнит поддержку системы;
- Микросервисные архитектуры требуют более квалифицированного персонала для создания и поддержки работоспособности.
