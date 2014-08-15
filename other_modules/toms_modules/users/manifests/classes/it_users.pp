# Class: users::it_users
#
# Manages  users and groups
# Include it to install the default set of users
#
# Usage:
# include users::it_users


class users::it_users inherits users {
  
  users::manage_user {"tmcgonagle":
    uid => "10007",
    gid => "10007",
    other_groups => ["wheel", "sysadmin", "logs", "dba", "build-devel", "puppet" ],
    password => '$1$L/t22Wp2$.TsUIN2lD7AAKT7mKeDWk1',
    comment => "Thomas A. McGonagle",
    #ssh_dss_auth_key => "AAAAB3NzaC1kc3MAAACBANS78QhK14OlNByi1RD+aqgSXaQhTSDDevGEVF/YyTHCr2sD+MsowevT74hFuDhl5HaBO9I+o1pLYQyOvUkAhc7Z31jQTPEAmd/FvbDAcT9+HEjmIxhKGC+DMVhyw8R4oBHXPY40SJyU74XTh7XnOQW0Ul8iJxuO+sAQCDbZ1MFlAAAAFQDTdwvwX95lGvtaPtn42bDDkuy0XQAAAIAoJimUMonrNrOHINo+REY4DhlgCiSmuYiW64Oifbdwlx6+q+lOf+drC5KLXTmKcuZ5avYCffitRZaDIZMjLol4eHkyIvTJ0k5dgXr31ByPGHdIPmDgEVZMOiCLQwlWIKa2m9DUVoi6AlXZKhaZS42EOM2qBMOEcRJURpc/WGC+mwAAAIA6Fsu2IbWG/uD4PBn4w1Y1X+NRFLWFywUwx5p9z/tWQcL7kKrBBLZjCsRXUfqeqzQDdNkAVFH7F4sRk33Gg4VGce2ooBeUfwqauvE6Bk0e8apaBdJtQ497zuCW8eWnt7gtH5Q+9Zf5j8V/p+MoIjiRt5GbBr/f7Dasaoq40GbTzw=",
    #ssh_rsa_auth_key => "AAAAB3NzaC1yc2EAAAABIwAAAQEA5a6bC/AupI9JQ6b2t69vuWe1vpHKNoAUiItnF2yfMBzuikY98x3xtWDTt/9c2dVAqAL2/6SEjreocFzVW2lHPvtObJVVkRV82Rs/PbMob/LHDpousjH5lVDh+LPDUVJDLEvmd7+bSO2559Ot5P32lUJlsKjNc+5j6nvzG225J9TbdPn7ayGJnJuI9IkowXPNVcYm0IEMnjDUfRDQmvh+tX4IFdEhcxs/JVVIs7yPd5YIwT/VbyC8bAdLt47gWRwQ5yc2WGPJV37nIJWq409TOHXv4I7GUEHNIPynad6Wgb+BL+cWSgi0PQZKSNACuNdt8FY+19INtSVCsjxEUnC3xQ==",
  }
  
  users::manage_user {"sfrattura":
    uid => "10004",
    gid => "10004",
    other_groups => ["wheel", "sysadmin", "logs", "dba", "build-devel" ],
    password => "\$1\$4zDo3.lC\$zaCGyjNjXixfew6S0e/t80",
    comment => "Sandro Fratura",
  }


  users::manage_user {"wflynn":
    uid => "10010",
    gid => "10010",
    other_groups => ["wheel", "sysadmin","logs", "dba", "build-devel" ],
    password => '$1$ic3Pxoef$7mYqLSpN1DHNNH2cbd40N/',
    comment => "Bill Flynn",
    #ssh_dss_auth_key => "AAAAB3NzaC1kc3MAAACBAMGWd8+LmkYfMDHzy6s/M7RIQU2k0MR09ZMQExPSpPkV6zANoSPO603la6sKKkBXI6yIVHZQ8tB6FD9AyVPTNZ7jZoV3yqayG6py4xvj2/8NagdjnkFLSptu6q8TWtudOqpHW61wiv9GioODRKZnteS5bSyKoRz5l8eJjhtyNf6BAAAAFQDgH6Ye/b3IrfvDy/t4+p/TbzWKtwAAAIEAvG1Cc/OYUV24ktM5WwptGGnBd8qRARtaPYoSjg8l+I9hcRLMhv7KLeozN2ZtNIGA3EsQGVLb4bkWQhVSygPDekPTR/vr+Bdo1pck6LJmri3eXva/CbQIfVnLv5RRVtsKIsoNekuTC2sBuu8WeH3NoIPnMRlzHpSrEY7bcumyjQkAAACAFof4JIX7uCXd5vURkf33TAIKYuT8hWX/pIPnwxzUGxxUnlJp++VQyao3nlI4plaLbgrheUkNCxpjVUqsBuheOk8Ba+CoyP3LifRbou/s5DBHNfrHV3/5oSbC1/ot3lm/Ky7MorsHQyfTShxzOULKiztmJP/eZUwvRm76WJgjUDY=",
  }

  users::manage_user {"jmarshal":
    uid => "10014",
    gid => "10014",
    other_groups => ["wheel", "sysadmin" ],
    password => "\$1\$0sv0YbNc\$uEl8JUAJzNGQWvhQ5m99Z.",
    comment => "Joseph Marshall",
  }

  users::manage_user {"jjoy":
    uid => "10018",
    gid => "10018",
    other_groups => ["wheel", "sysadmin", "logs" ],
    password => "\$1\$8mAGauqy\$3oQC6Hf4YOqsQhMBNZjoN1",
    comment => "Jason Joy",
  }

  users::manage_user {"dcote":
    uid => "10020",
    gid => "10020",
    other_groups => ["wheel", "sysadmin", "logs", "dba", "build-devel" ],
    password => "\$1\$F7zLAH6l\$oLW.S/V1W//8SP6UzEogk.",
    comment => "Don Cote",
  }
  
  users::manage_user {"kpanacy":
    uid => "10027",
    gid => "10027",
    other_groups => ["wheel", "sysadmin", "logs", "dba", "build-devel" ],
    password => "\$1\$JFc9qJM/\$aIXy/jl/x2lnEOiWret7p0", 
    comment => "Ken Panacy",
  }

  users::manage_user {"apradhan":
    uid              => "10029",
    gid              => "10029",
    other_groups     => ["wheel", "sysadmin", "logs", "dba", "build-devel" ],
    password         => "\$1\$SttRSB7z\$38GKSxDu.HCPuFpAN53Dx0", 
    comment          => "Akshat Pradhan",
    shell            => "/bin/zsh",
    #ssh_rsa_auth_key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAvHJeW+7r7YEoi8gWib75VwhubP+M/WbHbIQ/kdeBZa5dUZ6SBUi5nNPJpDMME7/k8CMiyEcnEHBmgMxYeku47ydnMtgDmTxce7p/348AYbrHW18/LNhmMuE5zUJzCWYqy4P+wBFLzWwHfQV5AMkSIVtyasC1XA997zJDQDdhglMzpfvxY4ot6CKCUD+Hbf3MfJgRRrqkp2fMSMZcQXJhHjpyAtftz8Xc0HQpjFXBgOOphx/CVRNjlKIcrUqFQYgvxLxdqrDCu8yehz5YJqZp09/gEuDn9t7vb+qs2SwmUYn2S3MgGcBjPf1P3HsOEd2NY8PNNV8DsY+YK1ncW/kBWQ==',
  }

  users::manage_user {"rtodd":
    uid => "10030",
    gid => "10030",
    other_groups => ["wheel", "sysadmin", "logs", "dba", "build-devel" ],
    password => "\$1\$ngVezYg4\$SNI6HQNw6lS/TnqEW/Mkh1", 
    comment => "Roy D. Todd II",
  }

  users::manage_user {"rpeachey":
    uid => "10075",
    gid => "10075",
    other_groups => ["wheel", "sysadmin", "logs", "dba", "build-devel" ],
    password => "\$1\$fwNCbMUu\$mcS4fAGAJQVGAfYmJ1SF60", 
    comment => "Raymond Peachey",
  }

}#end of users class
