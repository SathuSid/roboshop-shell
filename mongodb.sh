cp mongo.repo /etc/yum.repos.d/mongo.repo

sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
dnf install mongodb-org -y
systemctl enable mongod
systemctl restart mongod