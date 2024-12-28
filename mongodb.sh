source common.sh
app_name=mongodb

print_heading "copy mongodb repo file"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
status_check $?


print_heading "install mongodb"
dnf install mongodb-org -y &>>$log_file
status_check $?

print_heading "update the listener address"
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$log_file
status_check $?

print_heading "enable and restart mongodb service"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
status_check $?