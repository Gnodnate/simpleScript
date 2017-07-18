#!/bin/sh

outFile="output.mp4"
if [ -n $2 ]; then
    outFile=$2
    if [[ ! $outFile =~ ".mp4" ]]; then
        outFile=$2".mp4"
    fi
fi
echo "\033[7;30m Files will convert to "$outFile"\033[0m"

threadNum=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)

tsString=""
if [ -d $1 ] ; then
    for file in $1/*; do
        ext=".mp4"
        if [[ $file =~ ".mp4" ]]; then
            tsFile="/tmp/"$(basename $file ".mp4")".ts"
            if [ -z $tsString ]; then
                tsString=$tsFile
            else
                tsString=$tsString"|"$tsFile
            fi
            ffmpeg -threads $threadNum -i $file -c copy -bsf:v h264_mp4toannexb -f mpegts $tsFile
        fi
    done
    if [ -z $tsString ]; then 
	echo "No MP4 file need to be converted"
    else
        ffmpeg -threads $threadNum -i "concat:"$tsString -c copy -bsf:a aac_adtstoasc $1/$outFile
        rm -fr /tmp/*.ts
    fi
fi
