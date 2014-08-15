class manhunt::tools inherits manhunt {
	file {"/var/www/html/mhtools":
    		ensure  => directory,
		owner => "deploy", group => "creative-editors", mode => "2755", }

	file {"/var/www/html/mhtools/.htpasswd":
		content => template("manhunt/mhtools_htpasswd.tpl"),
		owner => "deploy", group => "creative-editors", mode => "2755", }

	file {"/var/www/html/mhtools/appyml.php":
    		source  => "puppet:///modules/manhunt/tools.appyml.php",
		owner => "root", group => "root", mode => "0755", }

}#end of class manhunt::tools
