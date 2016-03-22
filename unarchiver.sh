#/usr/bin/env bash

filecount=0
number=0

function unarchiver()
{
    file=$1
    if [  -d $file ]; then
        cd $file
        for i in `ls`; do
            unarchiver $i
        done
    elif [[ ${file/'.tar'/} != $file ]]; then
        tar xzf $file
        if [ $? -eq 0 ]; then
            rm -fr $file
        fi
        unarchiver ${file%.tar*}
    else
        ((filecount++))
        while read fileNumber; do
            echo "get $fileNumber in $file"
            ((number+=fileNumber))
        done < $file
    fi
}

unarchiver $1

echo "There are $filecount files"
echo "The number is $number"

