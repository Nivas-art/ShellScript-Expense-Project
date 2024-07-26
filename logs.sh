#!/bin/bash

SOURCE_DIRECTORY=/tmp/log-files
if [ -d $SOURCE_DIRECTORY ]
then
    echo "source directory here"
else
    echo "no directory"
    exit 1
fi

FILES=$(find $SOURCE_DIRECTORY -name "*.log" -mtime +14)

echo "files to delete: $FILES"