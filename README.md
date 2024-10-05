# Домашнее задание к занятию "Разбор скриптов и и их написание"

## Студент: Максимов Сергей Алексеевич

## Задание 1.

Дан скрипт:
![start_script](/resources/image1.png)
Измените скрипт так, чтобы:
* для ввода пользователем были доступны все параметры. Помимо существующих PREFIX и INTERFACE, сделайте возможность задавать пользователю SUBNET и HOST;
* скрипт должен работать корректно в случае передачи туда только PREFIX и INTERFACE
* скрипт должен сканировать только одну подсеть, если переданы параметры PREFIX, INTERFACE и SUBNET
* скрипт должен сканировать только один IP-адрес, если переданы PREFIX, INTERFACE, SUBNET и HOST
* не забывайте проверять вводимые пользователем параметры с помощью регулярных выражений и знака =~ в условных операторах
* проверьте, что скрипт запускается с повышенными привилегиями и сообщите пользователю, если скрипт запускается без них


## Решение

### Запуск с корректными данными
![correct1](/resources/image2.png)
![correct2](/resources/image3.png)
![correct3](/resources/image4.png)

### Проверка исключений
![Invalid](/resources/image5.png)