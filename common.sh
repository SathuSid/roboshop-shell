color="\e[35m"
no_color="\e[0m"
log_file=/tmp/roboshop.log
rm -f $log_file


app_prerequisites(){
  echo -e "$color Creating the roboshop user $no_color"
  useradd roboshop &>>$log_file
  echo

  echo -e "$color Extracting the input for dispatch api $no_color"
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
  curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$log_file
  cd /app
  unzip /tmp/$app_name.zip &>>$log_file
}