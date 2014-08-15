class cobbler_server {

  #cd /usr/share/puppet-dashboard/
  #rake RAILS_ENV=production db:create
  #rake RAILS_ENV=production db:migrate
  #cobbler replicate --master=cobbler.cambridge.manhunt.net --repos=* --distros=* --profiles=*
  #cobbler get-loaders
  #cobbler reposync

  package{"cobbler": ensure => latest }
  package{"cobbler-web": ensure => latest }
  package{"yum-downloadonly": ensure => latest }

  $cobbler_master = extlookup("common::cobbler_master") 
  include dhcpd
  include bind
  include httpd
  include xinetd
  #include rsync
  #include tftp
  include mysql::server::redhat

  file{"/var/www/html/index.html":
    	content => template("cobbler_server/index.html.erb"),
    	owner => "root", group => "root", mode => "0644", 
    	require => Package["cobbler"], }

  file{"/var/lib/cobbler/kickstarts/CentOS.ks":
    	source => "puppet:///modules/cobbler_server/kickstarts/CentOS.ks",
    	owner => "root", group => "root", mode => "0644",
    	require => Package["cobbler"],}

  file{"/var/lib/cobbler/kickstarts/CentOS+Build.ks":
    	source => "puppet:///modules/cobbler_server/kickstarts/CentOS+Build.ks",
    	owner => "root", group => "root", mode => "0644",
    	require => Package["cobbler"],}

  file{"/var/lib/cobbler/kickstarts/CentOS+MySQL.ks":
    	source => "puppet:///modules/cobbler_server/kickstarts/CentOS+MySQL.ks",
    	owner => "root", group => "root", mode => "0644",
    	require => Package["cobbler"],}

  file{"/var/lib/cobbler/kickstarts/core_puppet.ks":
    	source => "puppet:///modules/cobbler_server/kickstarts/core_puppet.ks",
    	owner => "root", group => "root", mode => "0644",
    	require => Package["cobbler"],}

  file{"/var/lib/cobbler/snippets/post_puppet_install":
    	source => "puppet:///modules/cobbler_server/post_puppet_install",
    	owner => "root", group => "root", mode => "0644",
    	require => Package["cobbler"],}
  
  file{"/etc/cobbler/settings":
    	content => template("cobbler_server/settings.erb"),
    	owner => "root", group => "root", mode => "0644", 
    	require => Package["cobbler"],
    	notify => Exec["/usr/bin/cobbler sync"], }

  file{"/etc/cobbler/rsync.template":
    	source => "puppet:///modules/cobbler_server/rsync.template",
    	owner => "root", group => "root", mode => "0644", 
    	require => Package["cobbler"], 
    	notify => Exec["/usr/bin/cobbler sync"], }

  exec{"/usr/bin/cobbler sync":
      path => "/usr/bin/",
      onlyif => "/bin/false",
    	require => Package["cobbler"],
    	notify => Service["cobblerd"], }

  file{"/etc/cobbler/modules.conf":
    	source => "puppet:///modules/cobbler_server/modules.conf",
    	owner => "root", group => "root", mode => "0644", 
    	require => Package["cobbler"],
    	notify => Service["cobblerd"], }
  

  file{"/tftpboot/linux-install":
    	ensure => directory,
    	owner => "root", group => "root", mode => "0755", 
    	require => Package["cobbler"],}

  file{"/tftpboot/linux-install/images":
    	ensure => link,
    	target => "../images", 
    	require => [ File["/tftpboot/linux-install"]],}

  file{"/tftpboot/linux-install/memdisk":
    	ensure => link,
    	target => "../memdisk", 
    	require => [ File["/tftpboot/linux-install"]],}

  file{"/tftpboot/linux-install/menu.c32":
    	ensure => link,
    	target => "../menu.c32", 
    	require => [ File["/tftpboot/linux-install"]],}

  file{"/tftpboot/linux-install/ppc":
    	ensure => link,
    	target => "../ppc", 
    	require => [ File["/tftpboot/linux-install"]],}

  file{"/tftpboot/linux-install/pxelinux.0":
    	ensure => link,
    	target => "../pxelinux.0", 
    	require => [ File["/tftpboot/linux-install"]],}

  file{"/tftpboot/linux-install/pxelinux.cfg":
    	ensure => link,
    	target => "../pxelinux.cfg", 
    	require => [ File["/tftpboot/linux-install"]],}

  file{"/tftpboot/linux-install/s390x":
    	ensure => link,
    	target => "../s390x", 
    	require => [ File["/tftpboot/linux-install"]],}
  
  file{"/etc/xinetd.d/tftp":
    	source => "puppet:///modules/cobbler_server/tftp",
    	owner => "root", group => "root", mode => "0644",
    	require => Package["cobbler"], 
    	notify => Service["xinetd"], }

  file{"/etc/xinetd.d/rsync":
    	source => "puppet:///modules/cobbler_server/rsync",
    	owner => "root", group => "root", mode => "0644",
    	require => Package["cobbler"],
    	notify => Service["xinetd"], }

  common::unarchive::tar-gz{"puppetmaster-training":
        module_url => "puppet:///modules/cobbler_server",
        file => "puppetmaster-training.tar.gz",
        untared_file => "puppetmaster-training",
        destination => "/var/www/html", }

  file{"/var/www/html/ProPuppet.pdf":
        source => "puppet:///modules/cobbler_server/ProPuppet.pdf",
        owner => "root", group => "root", mode => "0755", }
        

  service { "cobblerd":
    	enable => true,
    	ensure => running,
	    pattern => "/usr/bin/python /usr/bin/cobblerd --daemonize", }

#crons
if "${fqdn}" != "${cobbler_master}" {
  cron {"rsync-extlookup":
    command => "/usr/bin/rsync -avzH ${cobbler_master}::puppet-extdata /etc/puppet/manifests/extdata",
    user => "root",
    minute => "*/5", }  

  cron {"cobbler-replicate":
    command => "sudo cobbler replicate --master ${cobbler_master}",
    user => "root",
    minute => "*/5", }  
}#end of if

}#end of cobbler_server
