# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  os = "bento/ubuntu-18.04"
  net_ip = "192.168.50"
  machines = {
    "load-balancer" => { :ip => "192.168.50.220", :cpu => 1, :mem => 512},
    "web-1" => { :ip => "192.168.50.221", :cpu => 1, :mem => 512},
    "web-2" => { :ip => "192.168.50.222", :cpu => 1, :mem => 512},
    "database" => { :ip => "192.168.50.223", :cpu => 1, :mem => 512}
  }

  config.vm.define :master, primary: true do |master_config|
    master_config.vm.provider "virtualbox" do |vb|
        vb.memory = "512"
        vb.cpus = 1
        vb.name = "master"
    end
    
    master_config.vm.box = "#{os}"
    master_config.vm.host_name = 'saltmaster.local'
    master_config.vm.network "private_network", ip: "#{net_ip}.10"
    master_config.vm.synced_folder "saltstack/salt/", "/srv/salt"
    #master_config.vm.synced_folder "saltstack/pillar/", "/srv/pillar"

    master_config.vm.provision :salt do |salt|
      salt.master_config = "saltstack/etc/master"
      salt.master_key = "saltstack/keys/master_minion.pem"
      salt.master_pub = "saltstack/keys/master_minion.pub"
      salt.minion_key = "saltstack/keys/master_minion.pem"
      salt.minion_pub = "saltstack/keys/master_minion.pub"
      salt.seed_master = {
                          "web-1" => "saltstack/keys/web-1.pub",
                          "web-2" => "saltstack/keys/web-2.pub",
                          "database" => "saltstack/keys/database.pub",
                          "load-balancer" => "saltstack/keys/load-balancer.pub",
                         }

      salt.install_type = "stable"
      salt.install_master = true
      salt.no_minion = true
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end


  machines.each do |hostname, info|
    config.vm.define "#{hostname}" do |minion_config|
      minion_config.vm.provider "virtualbox" do |vb|
          vb.memory = "#{info[:mem]}"
          vb.cpus = "#{info[:cpu]}"
          vb.name = "#{hostname}"
      end

      minion_config.vm.box = "#{os}"
      minion_config.vm.hostname = "#{hostname}"
      minion_config.vm.network "private_network", ip: "#{info[:ip]}"

      minion_config.vm.provision :salt do |salt|
        salt.minion_config = "saltstack/etc/#{hostname}"
        salt.minion_key = "saltstack/keys/#{hostname}.pem"
        salt.minion_pub = "saltstack/keys/#{hostname}.pub"
        salt.install_type = "stable"
        salt.verbose = true
        salt.colorize = true
        salt.bootstrap_options = "-P -c /tmp"
      end
    end
  end
end
