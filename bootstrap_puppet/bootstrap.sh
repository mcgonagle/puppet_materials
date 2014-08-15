#!/bin/bash

#install epel and elff to install cobbler and puppet via gems
rpm -Uvh http://download.elff.bravenet.com/5/i386/elff-release-5-3.noarch.rpm
rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm 

#had a problem with libyaml dependency
#rpm -Uvh ftp://ftp.pbone.net/mirror/centos.karan.org/el5/extras/testing/x86_64/RPMS/libyaml-0.1.2-3.el5.kb.x86_64.rpm

#remove the old rpm puppet from epel
yum remove puppet facter

#install the latest rubygems package from elff
sudo yum install rubygems
gem install puppet
gem install facter

#install rack and passenger
#dependencies for passenger
yum install ruby-devel gcc gcc-c++ httpd-devel apr-devel mod_ssl
#gem install rack -v 1.1.0
#need to have ruby-devel installed to install passenger
rpm -Uvh http://cobitpd01.cambridge.manhunt.net/cobbler/repo_mirror/manhunt/rubygem-rack-1.1.0-2.el5.noarch.rpm
rpm -Uvh http://cobitpd01.cambridge.manhunt.net/cobbler/repo_mirror/manhunt/rubygem-rake-0.8.7-2.el5.noarch.rpm 
rpm -Uvh http://cobitpd01.cambridge.manhunt.net/cobbler/repo_mirror/manhunt/rubygem-fastthread-1.0.7-1.el5.x86_64.rpm 
rpm -Uvh http://cobitpd01.cambridge.manhunt.net/cobbler/repo_mirror/manhunt/rubygem-passenger-2.2.11-3.el5.x86_64.rpm
/usr/bin/passenger-install-apache2-module

#create the rack config directories
mkdir -p /etc/puppet/rack/puppetmaster/{public,tmp}
#copy a config.ru to the rack dir 
cp /usr/lib/ruby/gems/1.8/gems/puppet-2.6.8/ext/rack/files/config.ru /etc/puppet/rack/puppetmaster/config.ru
#change ownership of this file
chown -R puppet:puppet /etc/puppet/rack

#create /etc/httpd/conf.d/puppetmaster.conf with example from book
#create an /etc/puppet.conf and /etc/puppet/{modules,manifests} and an /etc/puppet/manifests/site.pp
mkdir -p /etc/puppet/{modules,manifests}
touch /etc/puppet/manifests/site.pp
#run the puppet master once to create the ssl certificates which will be used by apache

#make sure selinux is disabled, otherwise you won't be able to connect 
#to the cobbler web interface correctly or start the passenger app on 8140
echo 0 >/selinux/enforce

#edit /etc/selinux/config to turn off selinux 
#edit /etc/selinux/config
#http://www.crypt.gen.nz/selinux/disable_selinux.html

#grow the /var logcial volume
/usr/sbin/lvextend -L+40G /dev/vg00/lvVar00 
/sbin/resize2fs /dev/mapper/vg00-lvVar00

#install cobbler and cobbler-web from epel repo
yum install -y cobbler cobbler-web 

#must have cobblerd and httpd started and running to run the cobbler get-loaders
/sbin/service cobblerd start
/sbin/service httpd start  

#important to run cobbler get-loaders before running the replicate
/usr/bin/cobbler get-loaders
/usr/bin/cobbler replicate --master=cobitpd01.cambridge.manhunt.net --distros=* --profiles=* --repos=*

#/usr/bin/cobbler system add --name=$(hostname) --profile=CentOS-5.5-x86_64 --dns-name=$(hostname)
##to test puppet try a --noop run

#Install MySQL for use as a stored config
gem install rails -v 2.2.2
#http://projects.puppetlabs.com/projects/1/wiki/Using_Stored_Configuration
yum install mysql mysql-devel mysql-server
gem install mysql
#create the puppet database
/usr/bin/mysql -u root -e 'create database puppet;' 

#my.cnf changes to setup
#innodb_buffer_pool_size=2G
#innodb_log_file_size=256M
#innodb_log_buffer_size=64M
#innodb_additional_mem_pool_size=20M
#innodb_flush_method = O_DIRECT

#install puppet-dashboard via puppetlabs repo
rpm -Uvh http://yum.puppetlabs.com/base/puppetlabs-repo-3.0-2.noarch.rpm 
cd /usr/share/puppet-dashboard/
rake RAILS_ENV=production db:create
rake RAILS_ENV=production db:migrate

/sbin/service puppet-dashboard start


##########################################################################################################
##########################################################################################################
#configure ocsinventory databases
/usr/bin/mysql -u root -e 'create database ocsweb;'
/usr/bin/mysql -u root -e 'grant all on ocsweb.* to ocs@'localhost' identified by 'ocs'; flush privileges;'

/usr/bin/mysql -u root -e 'grant DROP,CREATE,INSERT,UPDATE,SELECT on events.* to zenoss identified by 'zenoss';'
/usr/bin/mysql -u root -e 'grant DROP,CREATE,INSERT,UPDATE,SELECT on events.* to zenoss@localhost identified by 'zenoss';'

# cd /var/lib/puppet/ssl/ca
# openssl rsa -in ca_key.pem -out ca_key_nopassphase.pem -passin file:private/ca.pass
# ln -s ca_key_nopassphase.pem certmaster.key
# ln -s ca_crt.pem certmaster.crt


ls /var/lib/puppet/ssl/ 

echo "make sure /etc/sysconfig/puppet && /etc/hosts is correct"
echo "and then restart httpd"
echo "have to visit http://localhost/ocsreports/install.php to set up ocs db"

cat /etc/sysconfig/puppet
cat /etc/hosts

echo "/sbin/service httpd restart"
git clone git@github.com:mcgonagletom/puppet_olb.git

#CREATE DATABASE `webistrano`;
#CREATE USER 'webistrano'@'localhost' IDENTIFIED BY 'password';
#grant all privileges on webistrano.* to 'webistrano'@'localhost' with grant option;
