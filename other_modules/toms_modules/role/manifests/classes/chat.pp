class role::chat inherits role {
  include smartfox
  include smartfox::memcache::populate 
}#end of role chat
