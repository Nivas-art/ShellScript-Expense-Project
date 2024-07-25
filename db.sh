#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log
R="\e[31m"
G="\e[32m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ge 0 ]
then
    echo "$2....FAILURE"
    exit 1
else
    echo "$2....PASS"
fi
}

if [ $USERID -ge 0 ]
then 
    echo "your not in root user"
    exit 1
else
    echo "your in root user"
fi


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "insatllation of mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabale of mysqld"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "started"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "password is set"
