source common.sh
app_name=mysql

if [ -z $1 ] ; then
  echo "password input is missing"
  exit 1
fi

MYSQL_ROOT_PASSWORD=$1

print_heading "install MySQL"
dnf install mysql-server -y &>>$log_file
status_check $?

print_heading "enable and start MySQL service"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
status_check $?

print_heading "setup MySQL password"
mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD &>>$log_file
status_check $?