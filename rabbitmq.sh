#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
# /var/log/shell-roboshop/rabbitmq.log

START_TIME=$(date +%s)
mkdir -p $LOGS_FOLDER
SCRIPT_DIR=$PWD
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

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "Copied rabbitmq.repo to install it"

dnf install rabbitmq-server -y  &>>$LOG_FILE
validate $? "Started rabbitmq"

systemctl enable rabbitmq-server &>>$LOG_FILE
validate $? "Started rabbitmq"

systemctl start rabbitmq-server &>>$LOG_FILE
validate $? "Started rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
validate $? "Created user roboshop with password"

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))
echo -e "Script excuted in: $Y $TOTAL_TIME Seconds $N"