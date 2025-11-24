#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
# /var/log/shell-roboshop/mysql.log

START_TIME=$(date +%s)
mkdir -p $LOGS_FOLDER
echo "Script started excuted at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script  with root previlage"
    exit 1
fi

validate(){
    if [ $1 -ne 0 ]; then
       echo -e "$2 .... $R FAILURE $N" | tee -a $LOG_FILE
       exit 1
    else
       echo -e "$2 .... $G SUCCESS $N" | tee -a $LOG_FILE
    fi 
}
dnf install mysql-server -y  &>>$LOG_FILE
validate $? "Installed mysql"

systemctl enable mysqld   &>>$LOG_FILE
validate $? "Enabled mysqld"

systemctl start mysqld   &>>$LOG_FILE
validate $? "started mysqld"

id root
if [ $? -ne 0 ]; then
   mysql_secure_installation --set-root-pass RoboShop@1
   validate $? "Created root user with password"
else
   echo -e "Root user already exists ... $Y SKIPPING $N"
fi

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))
echo -e "Script excuted in: $Y $TOTAL_TIME Seconds $N"