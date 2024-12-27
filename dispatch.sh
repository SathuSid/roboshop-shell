source common.sh
app_name="dispatch"

echo -e "$color Copying the dispatch service file $no_color"
cp dispatch.service /etc/systemd/system/dispatch.service &>>$log_file
echo $?

echo -e "$color Installing the golang $no_color"
dnf install golang -y &>>$log_file
echo $?
app_prerequisites

cd /app
echo -e "$color Download application dependencies $no_color"
go mod init dispatch &>>$log_file
go get &>>$log_file
go build &>>$log_file
echo $?

echo -e "$color restarting the dispatch service $no_color"
systemctl daemon-reload &>>$log_file
systemctl enable dispatch &>>$log_file
systemctl restart dispatch &>>$log_file
echo $?