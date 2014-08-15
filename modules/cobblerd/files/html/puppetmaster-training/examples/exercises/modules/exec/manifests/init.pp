class exec {
  
  exec { "touch /tmp/exec":
    path    => "/bin:/usr/bin",
    creates => "/tmp/exec",
  } # exec
} # class exec
