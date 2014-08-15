<?php	
define('ENVIRONMENT', 'dev');
set_time_limit(0); // kill execution time limit

// parse config file
require_once('lib/sfYaml.php');
$config = sfYaml::load('./app.yml');
$servers = $config[ENVIRONMENT]['chat']['hostnames'];
		
while (true) {
  $online = array();
    
  // check servers
  foreach ($servers as $hostname)
    if (strlen(file_get_contents("http://$hostname:8080/crossdomain.xml")) > 0)
      $online[] = $hostname;
    	       
  echo 'Online servers: ' . print_r($online, true) . "\n";
        
  // save online servers
  $server = $config[ENVIRONMENT]['memcacheChat']['host'];
  echo "Memcached server: $server\n";
  $server = explode(':', reset(explode(';', $server)));
        
  $memcached = new Memcache();
  $memcached->connect($server[0], $server[1]);
  $memcached->set($config[ENVIRONMENT]['chat']['online_list_key'], $online);
  $memcached->close();
    	
  file_put_contents('/var/log/healthcheck', print_r($online, true));
        
  sleep(30); // run every 30 seconds
 }