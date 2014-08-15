define manhunt::siteconfig($fsid, 
        $siteconf_name = "www", 
        $dbhost = "192.168.1.184",
        $dbmsghost1, 
        $dbmsghost2, 
        $dbmsghost3 = $dbmsghost1, 
        $dbslave,
        $dbuser = $mysql_webuser,
        $dbpass = $mysql_webpw, 
        $dbmanhunt = $orgname, 
        $dbmsg = "messages",
        $dbtrackhost = "192.168.1.226", 
        $dbtrack = "fast_tracklist",
        $dclk_ads_host = "mh.$orgdomain", 
        $secureserver_name = "secure.manhunt.net", 
        $site_name = "www.manhunt.net") {    

    file { "/etc/$orgname/siteconfig.inc.php":
        content => template("${orgname}/siteconfig.inc.php.erb"),
        owner => "root", group => "root", mode => "0644",
        require => File [ "/etc/$orgname" ]
    }       
}
