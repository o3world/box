sh DESTROY.sh
vagrant plugin install vagrant-vbguest
packer build setup/base.json
sh DESTROY.sh
