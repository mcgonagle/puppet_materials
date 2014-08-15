class appyml::xml inherits appyml {
  $xmlmobile_version = extlookup("${zone}::xmlmobile_version")
  file {"/usr/local/src/${xmlmobile_version}/apps/xmlmobile/config/app.yml":
        content => template("appyml/app.yml.xml.erb"),
        owner => "build", group => "build", mode => "0755",
        require => Common::Unarchive::Tar-gz["${xmlmobile_version}"], }
}#end of appyml::mh
