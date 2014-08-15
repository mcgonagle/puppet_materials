class appyml::mh inherits appyml {
  $mh_version = extlookup("${zone}::mh_version")
  file {"/usr/local/src/${mh_version}/apps/frontend/config/app.yml":
        content => template("appyml/${zone}/app.yml.mh.erb"),
        owner => "build", group => "build", mode => "0755",
        require => Common::Unarchive::Tar-gz["${mh_version}"], }

  file {"/usr/local/src/${mh_version}/apps/frontend/config/app.yml.test":
        content => template("appyml/app.yml.mh.erb"),
        owner => "build", group => "build", mode => "0755",
        require => Common::Unarchive::Tar-gz["${mh_version}"], }

  file{"/tmp/combined_app_yml.test":
        content => template("appyml/combined_app_yml"), }
}#end of appyml::mh
