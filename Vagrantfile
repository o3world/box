# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$sh_base = <<EOF
cd /sync
if [ ! -f conf.d/local.conf ]; then
	tar xvfp /tmp/sync_local.tgz
fi
if [ ! -f mysql.data/mysql/user.MYD ]; then
	tar xvfp /tmp/sync_mysql.tgz
fi
EOF

$sh_laravel = $sh_base + <<EOF
if [ ! -f conf.d/laravel.local.conf ]; then
	tar xvfp /tmp/sync_laravel.tgz
fi
EOF

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	config.vm.define "base", primary: true do |base|
		base.vm.box_url = "http://labs.o3dev.com/box/base.box"
		base.vm.box = "base"
		base.vm.synced_folder "/sync", "/sync", create: true, type: "nfs"
		base.vm.network "private_network", ip: "192.168.200.2"
		base.vm.network "forwarded_port", guest: 80, host: 8080
		base.vm.network "forwarded_port", guest: 443, host: 8443
		base.vm.provider :virtualbox do |vb|
			vb.name = "base"
		end
		base.vm.provision :shell, inline: $sh_base
	end

	config.vm.define "laravel" do |laravel|
		laravel.vm.box_url = "http://labs.o3dev.com/box/laravel.box"
		laravel.vm.box = "laravel"
		laravel.vm.synced_folder "/sync", "/sync", create: true, type: "nfs"
		laravel.vm.network "private_network", ip: "192.168.200.2"
		laravel.vm.network "forwarded_port", guest: 80, host: 8080
		laravel.vm.network "forwarded_port", guest: 443, host: 8443
		laravel.vm.provider :virtualbox do |vb|
			vb.name = "laravel"
		end
		laravel.vm.provision :shell, inline: $sh_laravel
	end

end
