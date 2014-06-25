box
====

**CentOS 6.5 64-bit LAMP** virtual machine ideal for local development

* **Remi** and **EPEL** repositories for **Yum**
* **NFS**, **Sendmail**, **Git**
* **Apache** 2, **MySQL** 5
* **PHP** 5 w/ extensions **mysql** **gd** **xml** **mbstring** **mcrypt**
* **NodeJS**, **NPM**, **Composer**, **Laravel** 4

----
Connectivity to VM's services, **from Host**:

* add to */etc/hosts* -- `192.168.200.2 local`
* NFS-sync'd folder created by Vagrant -- `~/sync`
* database -- `mysql -h192.168.200.2 -uroot -pvagrant`
* as an alternate to 80 and 443, port 8081 is "open" for TCP requests

----
To add an Apache **VirtualHost**:

* add to */etc/hosts* -- `192.168.200.2 example.local`
* *VirtualHost* definition -- `~/sync/conf.d/example.local.conf`
* `vagrant ssh`
* `sudo service httpd restart`

----
This VM is packaged as `base.box`

To use it, open **Terminal**, `cd box` then: `vagrant up`

Once running, if the services need to be (re)started, use:

`sudo sh /etc/start.sh` from within a `vagrant ssh` session.

----
The **screen** utility may be used to spawn **NodeJS** applications in a `vagrant ssh` session.

Similarly, the **artisan** tool for **Laravel** may be used in a terminal session.
