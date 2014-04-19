base-box/build
====

inspired by:
[github.com/kentaro/packer-centos-template](https://github.com/kentaro/packer-centos-template)

----
`sh BUILD.sh`

----

**Packer** will:

* obtain CentOS from one of the mirrors specified in **base.json**
* execute anaconda according to **kickstart.cfg**
* install a base CentOS system on top of that minimal kernel
* run **install.sh** on first boot to establish a web application stack

**Vagrant** will:

* install VirtualBox Guest Additions plugin
* clone a VirtualBox image from the system created by Packer
* set up a private network with ip address **192.168.200.2**
* forward port **80** to **8080** and port **443** to **8443**
* run **configure.sh** on first boot to set things up

Vital features of **install.sh**:

* create '**root**' user with password '**vagrant**'
* obtain **Remi** and **EPEL** repository database information
* install server daemons -- **NFS**, **Apache**, **MySQL**, **Sendmail**, **Git**
* install **PHP** w/ extensions **mysql** **gd** **xml** **mbstring** **mcrypt**

On first boot **configure.sh** adds:

* iptables configuration -- granting 'outside' access to ports **80**, **443** and **3306**
* creation of default **VirtualHost**
* creation of 'vanilla' **my.cnf** for MySQL
* grant of **MySQL** user '**root**' with password '**vagrant**' with broadest privileges

----
To this, **laravel.sh** adds:

* **Composer** and **Laravel**
* a VirtualHost definition -- `/sync/conf.d/laravel.local.conf`
* an initial Laravel project with updated `vendor/` packages

----
Use `DESTROY.sh` to remove all artifacts of the builds.
