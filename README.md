base-box
====

----
**CentOS 6.5 64-bit LAMP**

----

a **CentOS** virtual machine ideal for local development

* **Remi** and **EPEL** repositories for **Yum**
* **NFS**, **Apache** 2, **MySQL** 5, **Sendmail**, **Git**
* **PHP** 5.4 w/ extensions **mysql** **gd** **xml** **mbstring** **mcrypt**

Connectivity to VM's servers, **from Host**:

* add to /etc/hosts -- `192.168.200.2 local`
* NFS-sync'd folder created by Vagrant -- `/sync`
* database -- `mysql -h192.168.200.2 -uroot -pvagrant`

To add an *additional* Apache **VirtualHost**:

* add to /etc/hosts -- `192.168.200.2 example.local`
* vhost configuration -- `/sync/conf.d/example.local.conf`
* `vagrant ssh`
* `sudo service httpd restart`

This virtual machine is repackaged as `base.box`
and maintained at [vagrantcloud.com/o3world/base](https://vagrantcloud.com/o3world/base)

To use it, just:

`vagrant up`

Once running, if the services need to be restarted, use:

`sudo sh /etc/startup.sh`
