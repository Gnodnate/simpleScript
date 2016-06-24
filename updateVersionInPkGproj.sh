#!/bin/sh

cd `dirname $0`
if [ $# -lt 2 ];then
    echo "Need 2 argument"
    exit 1
fi

find "$1" -name *.pkgproj -print0 | xargs -0 -I {} packagesutil --file {}  set package-1 version $2

