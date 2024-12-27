source common.sh
app_name="payment"


echo -e "$color Copying the payment service file $no_color"
cp payment.service /etc/systemd/system/payment.service

echo -e "$color installing the python in payment micro service $no_color"
dnf install python3 gcc python3-devel -y

app_prerequisites

echo -e "$color installing the dependencies $no_color"
cd /app
pip3 install -r requirements.txt

echo -e "$color reloading and restarting payment service $no_color"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment