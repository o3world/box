sh DESTROY.sh
vagrant plugin install vagrant-vbguest
packer build setup/base.json
vagrant box add --provider virtualbox --name base base.box
vagrant up base

vagrant package --base base --output ../base.box

sh DESTROY.sh
vagrant plugin install vagrant-vbguest
vagrant box add --provider virtualbox --name laravel ../base.box
vagrant up laravel

vagrant package --base laravel --output ../laravel.box
