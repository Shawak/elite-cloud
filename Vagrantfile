# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"


  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end

  config.ssh.forward_agent = true

  config.vm.hostname = "cloud.elitepvpers.com"
  config.vm.network "private_network", ip: "90.90.90.91"
  config.vm.network "forwarded_port", guest: 85, host: 8082

  config.vm.synced_folder "./", "/var/www/elite-cloud", :nfs => !Vagrant::Util::Platform.windows?

  config.vm.provision :shell, path: "vagrant_bootstrap.sh"

end
