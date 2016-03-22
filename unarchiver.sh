#/usr/bin/env bash

filecount=0
number=0

function unarchiver()
{
    file=$1
    if [  -d $file ]; then
        for i in $file/*
        do
            unarchiver $i
        done
    elif [[ ${file/'.tar'/} != $file ]]; then
        tar xzf $file -C `dirname $file`
        if [ $? -eq 0 ]; then
            rm -fr $file
        fi
        unarchiver ${file%.tar*}
    else
        ((filecount++))
       read fileNumber < $file
       ((number+=fileNumber))
    fi
}

unarchiver $1

echo "There are $filecount files"
echo "The number is $number"

