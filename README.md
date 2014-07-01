box
====

**CentOS 6.5 64-bit LAMP** virtual machine ideal for local development

* **Remi** and **EPEL** repositories for **Yum**
* **NFS**, **Sendmail**, **Git**
* **Apache** 2 w/ **mod_ssl**, **MySQL** 5
* **PHP** 5 w/ extensions **mysql** **gd** **xml** **mbstring** **mcrypt**
* **NodeJS**, **NPM**, **rubygems**, **Composer**, **Laravel** 4
* **Sass**, **clean-css**, **uglify-js**

----
Connectivity to VM's services, **from Host OS**:

* add to */etc/hosts* -- `192.168.200.2 local`
* NFS-sync'd folder created by Vagrant -- `~/sync`
* database -- `mysql -h192.168.200.2 -uroot -pvagrant`
* as an alternate to 80 and 443, port 8081 is "open" for TCP requests

----
To add an Apache **VirtualHost**:

* add to */etc/hosts* -- `192.168.200.2 example.local`
* `vagrant ssh` or `ssh root@local`
* add *VirtualHost* definition -- `/etc/httpd/conf.d/example.local.conf`
* `sudo service httpd restart`

----
This VM is packaged as `base.box`

To use it, open **Terminal**, `cd box` then: `vagrant up`

----
The *deflate* "output filter" for Apache has been enabled for all requests except common image formats.
The timezone for PHP has been set to *America/New_York* and *zlib.output_compression* has been turned *On*.
The **screen** utility may be used to spawn **NodeJS** applications in a `vagrant ssh` session.
Similarly, the **artisan** tool for **Laravel** may be used in a terminal session.
The **Sass** "gem" has been installed on the VM as an alterative to executing it on the Host OS.
The **NodeJS** packages **clean-css** and **uglify-js** are installed globally
and may be executed as `cleancss` and `uglifyjs` to minify *.css* and *.js* files, respectively.
For more information, see:
[GoalSmashers/clean-css](https://github.com/GoalSmashers/clean-css)
and [mishoo/UglifyJS2](https://github.com/mishoo/UglifyJS2)
