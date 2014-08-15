class munin::server inherits munin {
  package{"munin": ensure => latest }

  file {"/etc/munin/munin.conf":
    content => template("munin/munin.conf.erb"),
    owner => "root", group => "root", mode => "0644", 
    require => Package["munin"], }

  File <<| tag == "munin_file" |>>

}#end of class munin::server
