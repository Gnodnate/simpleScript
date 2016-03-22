#! /bin/bash
 
var1="hello"
var2="dd"
 
#方法1
if [ ${var1:0:2} = $var2 ]; then
    echo "1:include"
fi
 
#方法2
echo "$var1" | grep -q "$var2"
if [ $? -eq 0 ]; then
    echo "2:include"
fi
 
#方法3
echo "$var1" |grep -q "$var2" && echo "include" ||echo "not"
 
#方法4
[[ ${var1/$var2/} != $var1 ]] && echo "include" || echo "not"

echo ${var1/$var2/}
