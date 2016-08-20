# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	config.vm.box = "ubuntu/trusty64"


	config.vm.provider "virtualbox" do |v|
		v.memory = 1024
	end

	config.ssh.forward_agent = true

	config.vm.hostname = "elite-cloud"
	config.vm.network "private_network", ip: "77.77.77.77"
	config.vm.network "forwarded_port", guest: 80, host: 8086

	config.vm.synced_folder "./", "/var/www", :nfs => !Vagrant::Util::Platform.windows?

	config.vm.provision :shell, path: "bootstrap.sh"

end