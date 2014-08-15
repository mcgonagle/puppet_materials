class appyml::gps inherits appyml {
  $gps_version = extlookup("${zone}::gps_version")
  file {"/usr/local/src/${gps_version}/apps/assfinder/config/app.yml":
        content => template("appyml/app.yml.gps.erb"),
        owner => "build", group => "build", mode => "0755",
        require => Common::Unarchive::Tar-gz["${gps_version}"], }
}#end of appyml::mh
