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

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "disable"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enable"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "installed"

id expense
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "added"
else
    echo -e "user already addedd...$G skipping $N"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "created"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "downloaded"

cd /app &>>$LOGFILE
VALIDATE $? "gone"

rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "unziped"

npm install &>>$LOGFILE
VALIDATE $? "installed"

cp /home/ec2-user/total-practi/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "copied"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "reloaded"

systemctl start backend &>>$LOGFILE
VALIDATE $? "started"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "enabled"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "install client"

mysql -h 172.31.90.94 -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "schema loaded"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "restared"
