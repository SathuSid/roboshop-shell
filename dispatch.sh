source common.sh

echo -e "$color Copying the dispatch service file $no_color"
cp dispatch.service /etc/systemd/system/dispatch.service

echo -e "$color Installing the golang $no_color"
dnf install golang -y

echo -e "$color Creating the roboshop user $no_color"
useradd roboshop

echo -e "$color Extracting the input for dispatch api $no_color"
rm -rf /app
mkdir /app
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip
cd /app
unzip /tmp/dispatch.zip

cd /app
echo -e "$color Download application dependencies $no_color"
go mod init dispatch
go get
go build

echo -e "$color restarting the dispatch service $no_color"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch