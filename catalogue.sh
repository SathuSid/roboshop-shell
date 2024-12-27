source common.sh
app_name=catalogue

cp catalogue.service /etc/systemd/system/catalogue.service


nodejs_setup

cp mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y
mongosh --host mongodb.siddevsecops.icu </app/db/master-data.js

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
