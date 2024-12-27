source common.sh
app_name=mysql

print_heading "install MySQL"
dnf install mysql-server -y &>>$log_file
status_check $?

print_heading "enable and start MySQL service"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
status_check $?

print_heading "setup MySQL password"
mysql_secure_installation --set-root-pass RoboShop@1 &>>$log_file
status_check $?