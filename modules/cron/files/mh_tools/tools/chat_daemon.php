<?php
/* systems should edit these first 3 accordingly... */
define('YML_FILE', '/etc/app_test.yml');
define('NAGIOS_LOG', '/tmp/nagios_test_log');
define('SLEEP_INTERVAL', 60);
define('ENVIRONMENT', 'all');
//define('ENVIRONMENT', isset($argv[1]) ? $argv[1] : 'dev');
define('SF_PORT', '443');
//require_once('/usr/local/manhunt/lib/sfYaml.php');

$memcachedKey = 'multichat_active_server';

set_time_limit(0); // let's run forever!

echo "daemon starting up using ". ENVIRONMENT. " settings...running sanity checks...\n";

//make sure we can write to our nagios log
if(!is_writable(NAGIOS_LOG) && !is_writable(dirname(NAGIOS_LOG))){
  die("\nERROR! I can't seem to write to the nagios logfile: ".NAGIOS_LOG.", check permissions on file or directory.\n");
}
//make sure we have a real YML to parse
if(!is_readable(YML_FILE)){
  die("\nERROR! Either I can't access the YML file or it doesn't exist, I'm looking for it here: ".YML_FILE."\n");
}
//$config = sfYaml::load(YML_FILE); //lets just make sure parsed config items are there, last sanity check
$config=array(
  'all'=>array(
    'multichat'=>array(
      'hostnames'=>array('66.151.184.201', '66.151.184.202', '209.67.254.143'), 
    ),
  'memcacheChat'=>array('host'=>'cache08.waltham.manhunt.net:11219')  
  )
);
//print_r($config);
if(!isset($config[ENVIRONMENT]['multichat']['hostnames']) || ! isset($config[ENVIRONMENT]['memcacheChat']['host'])){
  die("\nERROR! I can't seem to find the proper app.yml settings for ". ENVIRONMENT ."!\n");
}
echo "done, green across the board.\n";
$serverList = $config[ENVIRONMENT]['multichat']['hostnames'];
$memcachedString = $config[ENVIRONMENT]['memcacheChat']['host'];
if(strstr($memcachedString, ';')){ //old YML files seem to have multiple servers with ; delim ... weird
  $memcacheServerList = explode(';', $memcachedString);
}
else{
  $memcacheServerList = array($memcachedString);
}

while(true){ // let's run forever!
  $activeServers=array();
  foreach($serverList as $host){
    if(SmartfoxHealthChecker::checkServer($host, SF_PORT)){
      $activeServers[count($activeServers)] = $host;
    }
  }
  $logMsg = '- ACTIVE SERVERS = '.count($activeServers)."\n";
  if(count($activeServers) == count($serverList)){
    $logMsg = "OK $logMsg";
  }
  else{
    $logMsg = "NOK $logMsg"; 
  }
  echo "logging: $logMsg";
  file_put_contents(NAGIOS_LOG, $logMsg);
  
  foreach($memcacheServerList as $memcacheServer){
    echo "checking $memcacheServer...";
    $server = explode(':', $memcacheServer);
    $memcached = new Memcache();
    $memcached->connect($server[0], $server[1]);
    $currentServer = $memcached->get($memcachedKey);
    echo "MC says current server=$currentServer\n";
    $newServer=$currentServer;
    if($newServer === false || !in_array($newServer, $activeServers)){
	$newServer=$activeServers[0];
	"using NEW server\n";
    }
    else{
        echo "keeping OLD server\n";
    }
    $result = $memcached->set($memcachedKey, $newServer);
    echo "saving MC:$newServer...save result=$result\n";
    $memcached->close();
  }
  
  echo 'Sleeping for '. SLEEP_INTERVAL .' seconds...';
  sleep(SLEEP_INTERVAL);
  echo "done sleeping.\n";
}

class SmartfoxHealthChecker{

  private function __construct(){}

  public static function checkServer($host, $port){
    echo "checking $host:$port\n";
    $socket = @socket_create(AF_INET, SOCK_STREAM, SOL_TCP) or die("I cant create an INET TCP socket, let alone connect, something is very wrong...\n"); 
    $result = @socket_connect($socket, $host, $port);
    if($result === false || $result < 0){
      echo "checked returned FAILURE\n"; 
      return false;
    }
    echo "check returned SUCCESS\n";
    @socket_close($socket);
    return true;
  }
}
?>
