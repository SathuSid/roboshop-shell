source common.sh
app_name=redis

print_heading "disable Redis"
dnf module disable redis -y &>>$log_file
status_check $?

print_heading "enable Redis version 7"
dnf module enable redis:7 -y &>>$log_file
status_check $?

print_heading "install Redis"
dnf install redis -y &>>$log_file
status_check $?

print_heading "Update Redis Listener address"
sed -i -e 's/127.0.0.1/0.0.0.0/' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$log_file
status_check $?

print_heading ""
systemctl enable redis &>>$log_file
systemctl restart redis &>>$log_file
status_check $?