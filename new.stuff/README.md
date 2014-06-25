new.stuff
====

**a fork of the original repo to fix the 'root' login requirement**

----

You'll need to do this to get this VM running:

* brew install bindfs
* vagrant plugin install vagrant-vbguest
* vagrant plugin install vagrant-bindfs
* hardcode your host home directory in vagrantfile for now

Optional but recommended (https://docs.vagrantup.com/v2/synced-folders/nfs.html) so you don't have to provide host machine sudo credentials everytime vagrant wants to modify /etc/exports on the host machine, add to /etc/sudoers file:

Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
%admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE

* TODO: Merge this into original repo
* TODO: get $USER variable to output correctly in vagrantfile so it doenst need to be hardcoded.
* TODO: provide better documentation on how/why this works
* TODO: update URL for base.box in vagrantfile