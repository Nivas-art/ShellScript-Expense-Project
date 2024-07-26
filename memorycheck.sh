#!/bin/bash

DISK_USAGE=$(df -hT | grep xfs)
DISK_THRESHOLD=6
MESSAGE=" "

while IFS= read -r line
do
USAGE=$(echo $line | awk -F " " '{print $6F}' | cut -d "%" -f1)
FOLEDR=$(echo $line | awk -F " " '{print $NF}')
if [ $USAGE -ge $DISK_THRESHOLD ]
then 
    MESSAGE+="$FOLEDR: is more than $DISK_THRESHOLD: current usage: $USAGE" \n
fi
done <<<$DISK_USAGE

echo -e "message: $MESSAGE"