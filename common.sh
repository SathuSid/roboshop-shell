color="\e[35m"
no_color="\e[0m"
log_file=/tmp/roboshop.log
rm -f $log_file
scripts_path=$(pwd)


app_prerequisites(){
  print_heading "Creating the roboshop user"
  id roboshop &>>$log_file
  if [ $? -ne 0 ] ; then
    useradd roboshop &>>$log_file
  fi
  status_check $?

  print_heading "Extracting the input for dispatch api"
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
  status_check $?
  curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$log_file
  status_check $?
  cd /app
  unzip /tmp/$app_name.zip &>>$log_file
  status_check $?
}

print_heading(){
  echo -e "$color $1 $no_color" &>>$log_file
  echo -e "$color $1 $no_color"
}

status_check(){
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
    exit 1
  fi
}

systemd_setup(){
  print_heading "Copying service file into etc path"
  cp $scripts_path/$app_name.service /etc/systemd/system/$app_name.service &>>$log_file
  sed -i -e "s/RABBITMQ_PASSWORD/${RABBITMQ_PASSWORD}/" $scripts_path/$app_name.service &>>$log_file
  status_check $?

  print_heading "reloading and restarting the service"
  systemctl daemon-reload &>>$log_file
  systemctl enable $app_name &>>$log_file
  systemctl restart $app_name &>>$log_file
  status_check $?

}



nodejs_setup(){
  print_heading "disable nodejs"
  dnf module disable nodejs -y &>>$log_file
  status_check $?

  print_heading "enable nodejs 20"
  dnf module enable nodejs:20 -y &>>$log_file
  status_check $?

  print_heading "install nodejs"
  dnf install nodejs -y &>>$log_file
  status_check $?

  app_prerequisites

  cd /app
  print_heading "install nodejs dependencies"
  npm install &>>$log_file
  status_check $?

  systemd_setup
}


python_setup(){

  status_check $?

  print_heading "install Python"
  dnf install python3 gcc python3-devel -y &>>$log_file
  status_check $?

  app_prerequisites

  print_heading "download application Dependencies"
  pip3 install -r requirements.txt &>>$log_file
  status_check $?

  systemd_setup
}


maven_setup(){

  print_heading "install Maven"
  dnf install maven -y &>>$log_file
  status_check $?

  app_prerequisites

  print_heading "download application Dependencies"
  mvn clean package &>>$log_file
  status_check $?
  mv target/$app_name-1.0.jar $app_name.jar &>>$log_file
  status_check $?

  print_heading "install MySQL Client"
  dnf install mysql -y
  status_check $?

  for sql_file in schema app-user master-data; do
    print_heading "Load SQL file $sql_file"
    mysql -h mysql.siddevsecops.icu -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/$sql_file.sql &>>$log_file
    status_check $?
  done

  systemd_setup
}