source common.sh
app_name="dispatch"


print_heading "Copying the dispatch service file"
cp dispatch.service /etc/systemd/system/dispatch.service &>>$log_file
status_check $?

print_heading "Installing the golang"
dnf install golang -y &>>$log_file
status_check $?
app_prerequisites

cd /app
print_heading "Download application dependencies"
go mod init dispatch &>>$log_file
go get &>>$log_file
go build &>>$log_file
status_check $?

print_heading "restarting the dispatch service "
systemctl daemon-reload &>>$log_file
systemctl enable dispatch &>>$log_file
systemctl restart dispatch &>>$log_file
status_check $?