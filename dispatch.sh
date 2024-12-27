source common.sh
app_name="dispatch"

if [ -z $1 ] ; then
  echo "RabbitMQ password is missing"
  exit 1
fi
RABBITMQ_PASSWORD=$1

go_lang_setup
