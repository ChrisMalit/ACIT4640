#!/bin/bash

# User Setup

user_admin_setup() {
    	echo "Creating User"
    	useradd -m "admin" -p "P@ssw0rd";

    	usermod -a -G wheel admin;

	# SSH Setup
    	mkdir -p /home/admin/.ssh
    	echo "Setting up SSH Key"
    	cp ~/setup/acit_admin_id_rsa.pub /home/admin/.ssh/authorized_keys
}

# Firewall Setup
firewall_setup(){
    	echo "Configuring Firewall"

    	# HTTP - Port 80
    	firewall-cmd --zone=public --add-service=http
    	firewall-cmd --zone=public --add-port=80/tcp

    	# HTTPS - Port 443
    	firewall-cmd --zone=public --add-service=https
    	firewall-cmd --zone=public --add-port=443/tcp

    	# SSH - Port 22
    	firewall-cmd --zone=public --add-service=ssh
    	firewall-cmd --zone=public --add-port=22/tcp

   	# Save changes permanently
    	firewall-cmd --runtime-to-permanent
}

# Install & Update necessary Tools
package_installation(){
    	echo "Installing & Updating Required Packages"

    	# Epel-Release Repo
    	yum -y install epel-release git tcpdump curl net-tools vim

    	# Update existing tools
    	yum -y update

    	# Install missing tools
    	yum -y install nodejs npm
    	yum -y install mongodb-server
   	yum -y install nginx
}

# Shutdown SE Linux
turnoff_selinux(){
    	echo "SE Linux is shutting down"
	setenforce 0
	sed -r -i 's/SELINUX=(enforcing|disabled)/SELINUX=permissive/' /etc/selinux/config
}

# Todo App User
todoapp_user_setup(){
    	echo "Creating Todo App User"
	useradd -m -r todo_app && passwd -l todo_app
}

# Enable & Start Mongo
initialize_mongo(){
    	echo "MongoDB Server is starting.."
    	systemctl enable mongod && systemctl start mongod
}

# Web Service Setup
install_app_package(){
	echo "Configuring Database Configuration"
	cp ~/setup/database_config.js /home/todo-app/database.js
	cd /home/todo-app
	#sudo -u todo-app -H sh -c "
	su - todo-app bash -c "
		mkdir /home/todo-app/app;
		git clone https://github.com/timoguic/ACIT4640-todo-app.git /home/todo-app/app;
		cd /home/todo-app/app;
		npm install;
		mv /home/todo-app/database.js /home/todo-app/app/config/database.js;
	"
	chmod -R 755 /home/todo-app
}

# Daemon Setup
daemon_setup(){
	echo "Setting up Todo-App Daemon"
	cp ~/setup/todoapp.service /lib/systemd/system/todoapp.service
	systemctl daemon-reload
	systemctl enable todoapp && systemctl start todoapp
}

# NGinx Setup
setup_nginx(){
	echo "Starting Nginx"
	systemctl enable nginx && systemctl start nginx

    	echo "Configuring Nginx.conf"
	cp ~/setup/nginx.conf /etc/nginx/nginx.conf
	nginx -s reload
}

set -u 

echo "Initializing Setup"

echo "Done"

# Start Scripts
user_admin_setup
firewall_setup
package_installation
turnoff_selinux
todoapp_user_setup
initialize_mongo
install_app_package
daemon_setup
setup_nginx

echo "Setup completed."
