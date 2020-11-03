
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "4640BOX"
  config.ssh.username = "admin"
  config.ssh.private_key_path = "files/acit_admin_id_rsa"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "todohttp" do |todohttp|
    todohttp.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_HTTP_4640"
        vb.memory = 2048
    end
    todohttp.vm.hostname = "todohttp.bcit.local"
    todohttp.vm.network "private_network", ip: "192.168.150.10"
    todohttp.vm.network "forwarded_port", guest: 80, host: 12080
    todohttp.vm.provision "file", source: "./files/nginx.conf", destination: "/home/admin/nginx.conf"
    todohttp.vm.provision "file", source: "files/install_todoapp.sh", destination: "/tmp/install_todoapp.sh"
    todohttp.vm.provision "shell", inline: <<-SHELL
      dnf install -y nginx git nodejs
      mv /home/admin/nginx.conf /etc/nginx/nginx.conf

      useradd todoapp
      sudo -u todoapp bash /tmp/install_todoapp.sh

      systemctl enable nginx
      systemctl restart nginx
    SHELL
  end

  config.vm.define "tododb" do |tododb|
    tododb.vm.provider "virtualbox" do |vb|
        vb.name = "TODO_DB_4640"
        vb.memory = 1536
    end
    tododb.vm.hostname = "tododb.bcit.local"
    tododb.vm.network "private_network", ip: "192.168.150.20"
    tododb.vm.provision "file", source: "files/mongorepo.txt", destination: "/home/admin/mongorepo.txt"
    tododb.vm.provision "shell", inline: <<-SHELL
      firewall-cmd --zone=public --add-port=27017/tcp
      firewall-cmd --runtime-to-permanent
      
      mv /home/admin/mongorepo.txt /etc/yum.repos.d/mongodb-org-4.4.repo
      dnf install -y mongodb-org tar

      curl -u student:BCIT2020 https://acit4640.y.vu/docs/module06/resources/mongodb_ACIT4640.tgz --output /tmp/myfile.tgz

      systemctl enable mongod
      systemctl restart mongod
      sed -i -e 's/127.0.0.1/0.0.0.0/' "/etc/mongod.conf"
      systemctl restart mongod

      tar zxf /tmp/myfile.tgz
      mongorestore -d acit4640 /home/admin/ACIT4640
    SHELL
  end

  config.vm.define "todoapp" do |todoapp|
    todoapp.vm.provider "virtualbox" do |vb|
    vb.name = "TODO_APP_4640"
    vb.memory = 2048
    end
    todoapp.vm.hostname = "todoapp.bcit.local"
    todoapp.vm.network "private_network", ip: "192.168.150.30"
    todoapp.vm.provision "file", source: "files/todoapp.service", destination: "/home/admin/todoapp.service"
    todoapp.vm.provision "file", source: "files/install_todoapp.sh", destination: "/tmp/install_todoapp.sh"
    todoapp.vm.provision "shell", inline: <<-SHELL
      firewall-cmd --zone=public --add-port=8080/tcp
      firewall-cmd --runtime-to-permanent

      curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
      dnf install -y git nodejs

      useradd todoapp
      sudo -u todoapp bash /tmp/install_todoapp.sh
      mv /home/admin/todoapp.service /etc/systemd/system/todoapp.service

      systemctl daemon-reload
      systemctl enable todoapp
      systemctl restart todoapp
    SHELL
   end
end
