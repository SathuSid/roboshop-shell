source common.sh

color="\e[35m"
no_color="\e[0m"

echo -e "$color Copying the payment service file $no_color"
cp payment.service /etc/systemd/system/payment.service

echo -e "$color installing the python in payment micro service $no_color"
dnf install python3 gcc python3-devel -y

echo -e "$color creating roboshop user $no_color"
useradd roboshop
echo -e "$color making directory and extracting app-content $no_color"
rm -rf /app
mkdir /app
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip
cd /app
unzip /tmp/payment.zip

echo -e "$color installing the dependencies $no_color"
cd /app
pip3 install -r requirements.txt

echo -e "$color reloading and restarting payment service $no_color"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment