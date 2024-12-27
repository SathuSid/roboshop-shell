color="\e[35m"
no_color="\e[0m"


app_prerequisites(){
  echo -e "$color Creating the roboshop user $no_color"
  useradd roboshop

  echo -e "$color Extracting the input for dispatch api $no_color"
  rm -rf /app
  mkdir /app
  curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip
  cd /app
  unzip /tmp/$app_name.zip
}