#http://inservio.ba/blog/en/27/04/2010/sphinx-and-sphinxse
class sphinx {
 #package{"sphinx": ensure => latest }
 file{"/usr/lib64/mysql/plugin/sphinx.so.0.0.0":
	source => "puppet:///modules/sphinx/sphinxse/mysql_5.1.54_sphinx_1.10/sphinx.so.0.0.0",
	owner => "root", group => "root", mode => "0755", }

 file{"/usr/lib64/mysql/plugin/sphinx.so.0":
	ensure => link,
	target => "/usr/lib64/mysql/plugin/sphinx.so.0.0.0",
	require => File["/usr/lib64/mysql/plugin/sphinx.so.0.0.0"], }

 file{"/usr/lib64/mysql/plugin/sphinx.so":
	ensure => link,
	target => "/usr/lib64/mysql/plugin/sphinx.so.0.0.0", 
	require => File["/usr/lib64/mysql/plugin/sphinx.so.0.0.0"], }

 file{"/usr/lib64/mysql/plugin/sphinx.a":
	source => "puppet:///modules/sphinx/sphinxse/mysql_5.1.54_sphinx_1.10/sphinx.a",
	owner => "root", group => "root", mode => "0755", }

 file{"/usr/lib64/mysql/plugin/sphinx.la":
	source => "puppet:///modules/sphinx/sphinxse/mysql_5.1.54_sphinx_1.10/sphinx.la",
	owner => "root", group => "root", mode => "0755", }

 file{"/usr/lib64/mysql/plugin/sphinx.lai":
	source => "puppet:///modules/sphinx/sphinxse/mysql_5.1.54_sphinx_1.10/sphinx.lai",
	owner => "root", group => "root", mode => "0755", }

 file{"/usr/lib64/mysql/plugin/sphinx_la-snippets_udf.o":
	source => "puppet:///modules/sphinx/sphinxse/mysql_5.1.54_sphinx_1.10/sphinx_la-snippets_udf.o",
	owner => "root", group => "root", mode => "0755", }
}
