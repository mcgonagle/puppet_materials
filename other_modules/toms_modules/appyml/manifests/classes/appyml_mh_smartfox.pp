class appyml::mh_smartfox inherits appyml {
  $mh_version = extlookup("${zone}::mh_version")
  file {"/usr/local/manhunt/etc/app.yml":
        content => template("appyml/${zone}/app.yml.mh.erb"),
        owner => "build", group => "build", mode => "0755",}

}#end of appyml::mh::smartfox
