class role::lrm inherits role {
  #nfs mounts
  include nfs::export::mh_creative
}#end of role www
