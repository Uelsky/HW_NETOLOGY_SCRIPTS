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

### Скрипт
```
#!/bin/bash
PREFIX="${1:-NOT_SET}"
INTERFACE="$2"
SUBNET="${3:-NOT_SET}"
HOST="${4:-NOT_SET}"

trap 'echo "Ping exit (Ctrl-C)"; exit 1' 2

username=$(id -nu)
if [ "$username" != "root" ];
then
        echo "Must be root to run \"$(basename "$0")\"."
        exit 1
fi

[[ "$PREFIX" = "NOT_SET" ]] && { echo "\$PREFIX must be passed as first positional argument"; exit 1; }


if [[ -z "$INTERFACE" ]];
then
        echo "\$INTERFACE must be passed as second positional argument"
        exit 1
fi


pattern="^(2[0-5][0-5]|1[0-9][0-9]|[1-9]?[0-9])\.(2[0-5][0-5]|1[0-9][0-9]|[1-9]?[0-9])$"
if [[ "$PREFIX" =~ $pattern ]];
then
        if [[ "$INTERFACE" =~ ^[a-z][a-z][a-z][0-9]?[a-z]?[0-9]?$ ]];
        then

                if [[ "$SUBNET" =~ ^(2[0-5][0-5]|1[0-9][0-9]|[1-9]?[0-9])$ ]] || [[ "$SUBNET" = "NOT_SET" ]];
                then
                        if [[ "$HOST" =~ ^(2[0-5][0-5]|1[0-9][0-9]|[1-9]?[1-9])$ ]] || [[ "$HOST" = "NOT_SET" ]];
                        then

                                if [[ "$SUBNET" = "NOT_SET" ]];
                                then
                                        if [[ "$HOST" = "NOT_SET" ]];
                                        then
                                                for SUBNET in {0..255}
                                                do
                                                        for HOST in {1..255}
                                                        do
                                                                echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
                                                                arping -c 3 -i $INTERFACE $PREFIX"."$SUBNET"."$HOST 2> /dev/null
                                                        done
                                                done

                                        elif [[ "$HOST" != "NOT_SET" ]];
                                        then
                                                for SUBNET in {0..255}
                                                do
                                                        echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
                                                        arping -c 3 -i $INTERFACE $PREFIX"."$SUBNET"."$HOST 2> /dev/null
                                                done
                                        fi


                                elif [[ "$SUBNET" != "NOT_SET" ]];
                                then
                                        if [[ "$HOST" = "NOT_SET" ]];
                                        then
                                                for HOST in {1..255}
                                                do
                                                        echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
                                                        arping -c 3 -i $INTERFACE $PREFIX"."$SUBNET"."$HOST 2> /dev/null
                                                done

                                        elif [[ "$HOST" != "NOT_SET" ]];
                                        then
                                                echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
                                                arping -c 3 -i $INTERFACE $PREFIX"."$SUBNET"."$HOST 2> /dev/null
                                        fi
                                fi
                        else
                                echo "Invalid host"
                        fi
                else
                        echo "Invalid subnet"
                fi
        else
                echo "Invalid interface"
        fi
else
        echo "Invalid prefix"
fi

```

### Запуск с корректными данными
![correct1](/resources/image2.png)
![correct2](/resources/image3.png)
![correct3](/resources/image4.png)

### Проверка исключений
![Invalid](/resources/image5.png)