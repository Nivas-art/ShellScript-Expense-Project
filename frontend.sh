#!/bin/bash

USERID=$(id -u)

TIMESTAMP=$(date +%f-%h-%m-%s)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log
R="\e[31m"
G="\e[32m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
then
    echo -e "$2....$R FAILURE $N"
    exit 1
else
    echo -e "$2....$G PASS $N"
fi
}

if [ $USERID -ne 0 ]
then 
    echo "your not in root user"
    exit 1
else
    echo "your in root user"
fi

dnf install nginx -y 
VALIDATE $? "installed"

systemctl enable nginx
VALIDATE $? "enabled"

systemctl start nginx
VALIDATE $? "started"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "removed"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "downloaded"

cd /usr/share/nginx/html
VALIDATE $? "gone"

unzip /tmp/frontend.zip
VALIDATE $? "ziped"

cp /home/ec2-user/total-practi/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "coped"

systemctl restart nginx
VALIDATE $? "restarted"