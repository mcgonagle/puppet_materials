class mysql::server::sun::my_cnf inherits mysql::server {
 $template_name = inline_template("${role}.my.cnf.erb")
 File["/etc/my.cnf"]{ content => template("mysql/${product}/${template_name}")}
}
