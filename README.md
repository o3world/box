base-box
====

**CentOS 6.5 64-bit LAMP**

----

a **CentOS** virtual machine ideal for local development

* **Remi** and **EPEL** repositories for **Yum**
* **NFS**, **Apache** 2, **MySQL** 5, **Sendmail**, **Git**
* **PHP** 5.4 w/ extensions **mysql** **gd** **xml** **mbstring** **mcrypt**

Connectivity to VM's servers, **from Host**:

* add to */etc/hosts* -- `192.168.200.2 local`
* NFS-sync'd folder created by Vagrant -- `/sync`
* database -- `mysql -h192.168.200.2 -uroot -pvagrant`

To add an *additional* Apache **VirtualHost**:

* add to */etc/hosts* -- `192.168.200.2 example.local`
* *VirtualHost* definition -- `/sync/conf.d/example.local.conf`
* `vagrant ssh`
* `sudo service httpd restart`

This virtual machine is packaged as `base.box`
To use it, open **Terminal**, `su root` then:

`vagrant up`

Once running, if the services need to be restarted, use:

`sudo sh /etc/startup.sh`

from within a `vagrant ssh` session.

----

A second machine for **Laravel** development is also in place.

* *vhost* should already exist  -- `/sync/conf.d/laravel.local.conf`
* add to */etc/hosts* -- `192.168.200.2 laravel
* `vagrant up laravel`
* `vagrant ssh laravel`
* `sudo sh /etc/startup.sh`
* [laravel.local](http://laravel.local) should display "You have arrived."

Laravel's **artisan** command-line utility may be used within a `vagrant ssh laravel` session.

This VM is packaged as `laravel.box`
To use it, `vagrant up laravel`

