# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	config.vm.define "base", primary: true do |base|
		base.vm.box = "o3world/base"
		base.vm.synced_folder "/sync", "/sync", create: true, type: "nfs"
		base.vm.network "private_network", ip: "192.168.200.2"
		base.vm.network "forwarded_port", guest: 80, host: 8080
		base.vm.network "forwarded_port", guest: 443, host: 8443
		base.vm.provider :virtualbox do |vb|
			vb.name = "base"
		end
	end

	config.vm.define "laravel" do |laravel|
		laravel.vm.box = "o3world/laravel"
		laravel.vm.synced_folder "/sync", "/sync", create: true, type: "nfs"
		laravel.vm.network "private_network", ip: "192.168.200.2"
		laravel.vm.network "forwarded_port", guest: 80, host: 8080
		laravel.vm.network "forwarded_port", guest: 443, host: 8443
		laravel.vm.provider :virtualbox do |vb|
			vb.name = "laravel"
		end
	end

end
