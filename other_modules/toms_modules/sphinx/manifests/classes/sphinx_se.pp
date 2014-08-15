class sphinx::se inherits sphinx {
 $sphinx_mysql_version = "5.1.54"
 $sphinx_version = "1.10"

 file{"/usr/lib64/mysql/plugins/sphinx.so.0.0.0":
  #source => "puppet:///modules/sphinx/sphinxse/mysql_5.1.54_sphinx_1.10/sphinx.so.0.0.0",
  source => "puppet:///modules/sphinx/sphinxse/mysql_${sphinx_mysql_version}_sphinx_${sphinx_version}/sphinx.so.0.0.0",
  owner => "root", group => "root", mode => "0644", 
  require => Package["sphinx"], }

 file{"/usr/lib64/mysql/plugins/sphinx.so.0":
          ensure => link,
          target => "/usr/lib64/mysql/plugins/sphinx.so.0.0.0",
          require => Package["sphinx"], }

 file{"/usr/lib64/mysql/plugins/sphinx.so":
          ensure => link,
          target => "/usr/lib64/mysql/plugins/sphinx.so.0.0.0",
          require => Package["sphinx"], }
}
