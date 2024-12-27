source common.sh
app_name=catalogue




nodejs_setup

print_heading "copy MongoDB repo file"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
status_check $?

print_heading "install MongoDB"
dnf install mongodb-mongosh -y &>>$log_file
status_check $?

print_heading "load the data into MongoDB"
mongosh --host mongodb.siddevsecops.icu </app/db/master-data.js &>>$log_file
status_check $?

print_heading "restart catalogue service"
systemctl restart catalogue &>>$log_file
status_check $?
