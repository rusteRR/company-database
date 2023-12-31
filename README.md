# Корпоративная база данных

## Структура данных 

БД включает в себя следующие сущности:

Сущности измерения:
- Сотрудник
- Пропуск
- Переговорная комната
- Должность
- Офис

Сущности факты:
- Бронирование переговорки - факт бронирования сотрудником переговорной комнаты с `date_from` до `date_to`
- Вход/выход из офиса - факт входа или выхода сотрудника из офиса, фиксируется время факта и пропуск 

## Проектирование

Концептуальные, логические и физические модели представлены [тут](company_database_design.pdf)

## Версионирование

Поддерживается версионирование типа `SCD 4` для сущности `employee`

Почему `SCD 4`:
- Быстрая работа с текущей версией, в отличие от `SCD 2`. Большинство запросов будет требовать именно актуальную версию сотрудника, поэтому нам выгодно хранить только их в отношении `employee`. Остальные версии вынесены в отдельную сущность `employee_versions`


## Проектирование 


> By Alexander Vinogradov, Alexander Mosin, Artem Sidorenko, Ivan Peshkov
>
> **@** _The Higher School of Economics, third year Database group project, 2023_