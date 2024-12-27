source common.sh
app_name="dispatch"

echo -e "$color Copying the dispatch service file $no_color"
cp dispatch.service /etc/systemd/system/dispatch.service

echo -e "$color Installing the golang $no_color"
dnf install golang -y

app_prerequisites

cd /app
echo -e "$color Download application dependencies $no_color"
go mod init dispatch
go get
go build

echo -e "$color restarting the dispatch service $no_color"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch