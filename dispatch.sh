echo -e "\e[35m Copying the dispatch service file \e[0m"
cp dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[35m Installing the golang \e[0m"
dnf install golang -y

echo -e "\e[35m Creating the roboshop user \e[0m"
useradd roboshop

echo -e "\e[35m Extracting the input for dispatch api \e[0m"
rm -rf /app
mkdir /app
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip
cd /app
unzip /tmp/dispatch.zip

cd /app
echo -e "\e[35m Download application dependencies \e[0m"
go mod init dispatch
go get
go build

echo -e "\e[35m restarting the dispatch service \e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch