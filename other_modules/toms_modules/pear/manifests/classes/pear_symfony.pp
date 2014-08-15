class pear::symfony inherits pear {
  $symfony_version = extlookup("${product}::symfony_version","symfony/symfony-1.0.17")
  exec {"pear channel-discover pear.symfony-project.com":
    	path => "/bin:/usr/bin:/usr/local/bin:/usr/sbin",
    	unless => 'echo `pear list-channels`|grep "symfony" >/dev/null',
    	require => Package[php-pear],
    	alias => "symfony channel-discover" }

  exec {"pear install ${symfony_version}":
    	path => "/bin:/usr/bin:/usr/local/bin:/usr/sbin",
    	onlyif => 'echo `pear list -c symfony`|grep "no packages" >/dev/null',
    	require => [ Package[php-pear], Exec['symfony channel-discover']],
    	alias => "pear install ${symfony_version}" }

 file {"/usr/share/pear/data/symfony/config":
	ensure => directory,
   	owner => "root", group => "root", mode => "0644", }
	
 file {"/usr/share/pear/data/symfony/config/php.yml":
   	source => "puppet:///modules/php/php.yml",
   	owner => "root", group => "root", mode => "0644", }
}#end of class pear::symfony
