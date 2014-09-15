# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

pubKeyFile = 'id_rsa.pub'
pubKeyPath = ENV['HOME'] + '/.ssh/' + pubKeyFile
baseMachine = '.vagrant/machines/base/virtualbox'
pubKeyForRoot = 'echo "PLEASE RUN [ vagrant reload --provision ] AFTER FIRST BOOT"'
if File.exist?( pubKeyPath ) && File.exist?( baseMachine )
	FileUtils.cp( pubKeyPath, baseMachine )
	sshDir = '/root/.ssh'
	sshKeys = sshDir + '/authorized_keys'
	pubKeyForRoot = 'mkdir -p ' + sshDir +
	 	' && cat /vagrant/' + baseMachine + '/' + pubKeyFile + ' > ' + sshKeys +
		' && echo "YOU MAY NOW [ ssh root@local ] WITHOUT A PASSWORD"'
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	config.vm.define "base", primary: true do |base|
		base.vm.box_url = "http://labs.o3dev.com/box/base.box"
		base.vm.box = "base"
		base.vm.synced_folder ENV['HOME'] + "/sync", "/sync", create: true, type: "nfs"
		base.vm.network "private_network", ip: "192.168.200.2"
		base.vm.network "forwarded_port", guest: 80, host: 8080
		base.vm.boot_timeout = 300
		base.vm.provider :virtualbox do |vb|
			vb.name = "base"
		end
		base.vm.provision :shell, inline: pubKeyForRoot
	end

end

