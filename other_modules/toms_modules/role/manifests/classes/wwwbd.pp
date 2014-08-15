class role::wwwbd inherits role {
    #include httpd
    include php
    include maxmind
      # bbd stuff
      include vhosts::bbd
#      include bigbearden::yml_configs
      include imagick
      include role::mcache

    #crons
    include cron::v4_webroller
    include cron::http_integrity_check
    #cron to remove www logs older than 7 days
    cron{"remove www logs":
    	command => 'find /var/www/html -type f -mtime 7 -exec rm {} \;',
	user => root,
	hour => [ '0-23' ], }

    #splunk
    #include splunk::client::httpd

    #munin plugins
    #include munin::plugin::apache

    #nfs mounts
    include nfs::export::weblogs

}#end of role::wwwbd
