source common.sh
app_name=frontend


print_heading "disable nginx"
dnf module disable nginx -y &>>$log_file
status_check $?

print_heading "enable nginx 24"
dnf module enable nginx:1.24 -y &>>$log_file
status_check $?

print_heading "install nginx"
dnf install nginx -y &>>$log_file
status_check $?

print_heading "copy nginx conf file"
cp nginx.conf /etc/nginx/nginx.conf &>>$log_file
status_check $?

print_heading "remove existing content"
rm -rf /usr/share/nginx/html/* &>>$log_file
status_check $?

print_heading "download the app-content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$log_file
status_check $?

print_heading "extract the app-content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$log_file
status_check $?

print_heading "restart and enable the nginx service"
systemctl restart nginx &>>$log_file
systemctl enable nginx &>>$log_file
status_check $?
