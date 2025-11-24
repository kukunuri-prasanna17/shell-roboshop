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
# /var/log/shell-roboshop/user.log

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

dnf install python3 gcc python3-devel -y &>>$LOG_FILE

id roboshop  &>>$LOG_FILE
if [ $? -ne 0 ]; then
     useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
     validate $? "Creating system user"
else
    echo -e "User already exists ...$Y SKIPPING $N"
fi

mkdir -p /app 
validate $? "Creating app directory"

curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip   &>>$LOG_FILE
validate $? "Creating app directory"

cd /app 
validate $? "Changing app directory"

rm -rf /app/*
validate $? "Removing existing data"

unzip /tmp/payment.zip &>>$LOG_FILE
validate $? "Unzip payment"

pip3 install -r requirements.txt &>>$LOG_FILE
validate $? "Install dependecies"

cp $SCRIPT_DIR/payment.service /etc/systemd/system/payment.service 
systemctl daemon-reload
systemctl enable payment &>>$LOG_FILE
validate $? "Enable payment"

systemctl restart payment 
validate $? "Restarted payment"


