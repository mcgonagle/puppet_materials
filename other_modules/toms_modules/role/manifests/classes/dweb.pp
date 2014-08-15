class role::dweb inherits role {
    include httpd
    include php
    include phpkb
    include maxmind
     
    #I think this will get set by the profile specified in cobbler
    #need to remove yumrepos::remi::enabled
    include yumrepos::remi::enabled

    include mount::mh::media 
    include vhosts::manhunt

    include product::mh::deploy_manhunt
    include product::mh::deploy_gps
    include product::mh::deploy_mobile
    include product::mh::deploy_xmlmobile
    include product::mh::tools

    #crons
    include cron::v4_webroller
    include cron::http_integrity_check

    cron{"remove www logs":
    	command => 'find /var/www/html -type f -mtime 7 -exec rm {} \;',
	user => root,
	hour => [ '0-23' ], }

    #will need to double check this and make sure it is how we want to do it
    #going forward 
    file { "${cron_dir}/hostchecker.pl":
    	source => "puppet:///modules/product/mh/tools/hostchecker.pl",
    	owner => "root", group => "root", mode => "0755", }

    #splunk
    #include splunk::client::httpd

    #munin plugins
    #include munin::plugin::apache

    #nfs mounts
    include nfs::export::weblogs

}#end of role::www
