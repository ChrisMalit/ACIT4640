#!/bin/bash

APP="/home/todoapp/app"
REPORT_URL="https://github.com/timoguic/ACIT4640-todo-app.git"

git clone $REPORT_URL $APP
npm install --prefix $APP
sed -i -e 's/CHANGEME/acit4640/' "${APP}/config/database.js"
sed -i -e 's/localhost/192.168.150.20/' "${APP}/config/database.js"
chmod a+rx /home/todoapp