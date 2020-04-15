#!/bin/bash

URL=${1:-"localhost/productpage"}

cnt=0
while true
do
    let "cnt += 1"
    echo "${cnt} : curl ${URL}"
    curl ${URL} > /dev/null 2>&1
    sleep 1
done