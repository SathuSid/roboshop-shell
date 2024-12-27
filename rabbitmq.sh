source common.sh
app_name=rabbitmq

if [ -z $1 ] ; then
  echo "RabbitMQ password is missing in RabbitMQ Server"
  exit 1
fi

RABBITMQ_PASSWORD=$1

print_heading "copy RabbitMQ repo to etc path"
cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$log_file
status_check $?

print_heading "install RabbitMQ server"
dnf install rabbitmq-server -y &>>$log_file
status_check $?

print_heading "enable and restart RabbitMQ service"
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
status_check $?

print_heading "add user and provide permissions to it in RabbitMQ server"
rabbitmqctl add_user roboshop $RABBITMQ_PASSWORD &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
status_check $?