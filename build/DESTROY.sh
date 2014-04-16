VBoxManage list runningvms|awk '{print $2;}'|xargs -I vmid VBoxManage controlvm vmid poweroff

vagrant box remove base
vagrant destroy base -f
vagrant box remove laravel
vagrant destroy laravel -f

rm -rf $HOME/VirtualBox\ VMs/base*
rm -rf $HOME/.vagrant.d/boxes/base
rm -rf $HOME/VirtualBox\ VMs/laravel*
rm -rf $HOME/.vagrant.d/boxes/laravel

rm -rf packer_cache
rm -rf output-virtualbox-iso
rm -rf .vagrant
rm -rf ../.vagrant

rm -f base.box
rm -f ../base.box
rm -f ../laravel.box
