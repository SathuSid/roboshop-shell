source common.sh
app_name=shipping

if [ -z $1 ] ; then
  echo "MySql input password is missing"
  exit 1
fi

MYSQL_ROOT_PASSWORD=$1

maven_setup

print_heading "install MySQL Client"
dnf install mysql -y
status_check $?

print_heading "running for loop to load master data into MySQL"
for sql_file in schema app-user master-data; do
  print_heading "Load SQL file $sql_file"
  mysql -h mysql.siddevsecops.icu -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/$sql_file.sql &>>$log_file
  status_check $?
done

print_heading "Restart Shipping Service"
systemctl restart shipping
status_check $?
