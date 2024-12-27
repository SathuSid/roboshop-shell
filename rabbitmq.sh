source common.sh
app_name=rabbitmq

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
rabbitmqctl add_user roboshop roboshop123 &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
status_check $?