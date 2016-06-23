#!/bin/sh

arr=("abc def" "def ghi")

for var in ${arr[@]}
do
    echo $var
done

for ((i=0;i<${#arr[@]};i++))
do
   echo ${arr[$i]}
done
