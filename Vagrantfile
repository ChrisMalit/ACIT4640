
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "4640BOX"
  config.ssh.username = "admin"
  config.ssh.private_key_path = "./acit_admin_id_rsa"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "todohttp" do |todohttp|
    todohttp.vm.provider "virtualbox" do |vb|
      vb.name = "TODO_HTTP_4640"
      vb.memory = 2048
    end
    todohttp.vm.hostname = "todohttp.bcit.local"
    todohttp.vm.network "private_network", ip: "192.168.150.10"
    todohttp.vm.network "forwarded_port", guest: 80, host: 12080
    todohttp.vm.provision "file", source: "./ansible", destination: "/home/admin/ansible"
    todohttp.vm.provision "ansible_local" do |ansible|
      ansible.provisioning_path = "/home/admin/ansible"
      ansible.playbook = "/home/admin/ansible/todohttp.yaml"
    end
  end

  config.vm.define "tododb" do |tododb|
    tododb.vm.provider "virtualbox" do |vb|
      vb.name = "TODO_DB_4640"
      vb.memory = 1536
    end
    tododb.vm.hostname = "tododb.bcit.local"
    tododb.vm.network "private_network", ip: "192.168.150.20"
    tododb.vm.provision "file", source: "./ansible", destination: "/home/admin/ansible"
    tododb.vm.provision "ansible_local" do |ansible|
      ansible.provisioning_path = "/home/admin/ansible"
      ansible.playbook = "/home/admin/ansible/tododb.yaml"
    end
  end

  config.vm.define "todoapp" do |todoapp|
    todoapp.vm.provider "virtualbox" do |vb|
      vb.name = "TODO_APP_4640"
      vb.memory = 2048
    end
    todoapp.vm.hostname = "todoapp.bcit.local"
    todoapp.vm.network "private_network", ip: "192.168.150.30"
    todoapp.vm.provision "file", source: "./ansible", destination: "/home/admin/ansible"
    todoapp.vm.provision "ansible_local" do |ansible|
      ansible.provisioning_path = "/home/admin/ansible"
      ansible.playbook = "/home/admin/ansible/todoapp.yaml"
    end
  end
end

