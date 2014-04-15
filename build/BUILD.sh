vagrant plugin install vagrant-vbguest
packer build setup/base.json

vagrant box add base base.box
vagrant up base

rm -f base.box
vagrant package base --output ../base.box
