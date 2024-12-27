color="\e[35m"
no_color="\e[0m"
log_file=/tmp/roboshop.log
rm -f $log_file


app_prerequisites(){
  print_heading "Creating the roboshop user"
  useradd roboshop &>>$log_file
  echo

  print_heading "Extracting the input for dispatch api"
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
  curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$log_file
  cd /app
  unzip /tmp/$app_name.zip &>>$log_file
}

print_heading(){
  echo -e "$color $1 $no_color" &>>$log_file
  echo -e "$color $1 $no_color"
}

