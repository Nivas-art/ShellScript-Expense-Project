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
    echo "$2....$R FAILURE $N"
    exit 1
else
    echo "$2....$G PASS $N"
fi
}

if [ $USERID -ne 0 ]
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
