#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.daws86s.cfd
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
# /var/log/shell-roboshop/cart.log

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

dnf module disable nodejs -y &>>$LOG_FILE
validate $? "disable nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
validate $? "enabling nodejs 20"

dnf install nodejs -y &>>$LOG_FILE
validate $? "Installing nodejs"

id roboshop  &>>$LOG_FILE
if [ $? -ne 0 ]; then
     useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
     validate $? "Creating system user"
else
    echo -e "User already exists ...$Y SKIPPING $N"
fi

mkdir -p /app 
validate $? "Creating app directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip  &>>$LOG_FILE
validate $? "Creating app directory"

cd /app 
validate $? "Changing app directory"

rm -rf /app/*
validate $? "Removing existing data"

unzip /tmp/cart.zip &>>$LOG_FILE
validate $? "Unzip cart"

npm install &>>$LOG_FILE
validate $? "Install dependecies"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
validate $? "Copy systemctl service"

systemctl daemon-reload
systemctl enable cart &>>$LOG_FILE
validate $? "Enable cart "

systemctl restart cart 
validate $? "Restarted cart"