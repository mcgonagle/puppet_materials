class appyml::mo inherits appyml {
  $mobile_version = extlookup("${zone}::mobile_version")
  file {"/usr/local/src/${mobile_version}/apps/frontend/config/app.yml":
        content => template("appyml/app.yml.mo.erb"),
        owner => "build", group => "build", mode => "0755",
        require => Common::Unarchive::Tar-gz["${mh_version}"], }
}#end of appyml::mh
