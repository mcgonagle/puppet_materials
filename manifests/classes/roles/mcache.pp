# Class: role::mcache
#
# This module manages role::mcache
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class role::mcache {
  include memcached

  class { "memcached::config::null":
   memcached_instance => "null",
   memcached_port => "11211", }

  class { "memcached::config::ent":
   memcached_instance => "ent",
   memcached_port => "11213", }

  class { "memcached::config::gen":
   memcached_instance => "gen",
   memcached_cachesize => "5116", 
   memcached_port => "11215", }

  class { "memcached::config::sess":
   memcached_instance =>  "sess",
   memcached_port => "11217", }

  class { "memcached::config::chat":
   memcached_instance => "chat",
   memcached_port => "11219", }

  class { "memcached::config::ads": 
   memcached_instance => "ads",
   memcached_port => "11221", }

  class { "memcached::config::img":
   memcached_instance =>  "img",
   memcached_cachesize => "2048", 
   memcached_port => "11231", }
}
