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

