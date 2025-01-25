#!/usr/bin/env bash

now=$(date +%s)
end=$(($now + $1))
while (( now < end )); do
    printf "%s\r" "$(date -u -j -f %s $(($end - $now)) +%T)"
    sleep 1
    now=$(date +%s)
done
say "beep"

