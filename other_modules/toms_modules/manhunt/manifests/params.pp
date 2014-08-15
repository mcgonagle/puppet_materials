class manhunt::params {

 $js_master_version = extlookup("${zone}::js_master_version")
  notice("$js_master_version")
 $mh_version = extlookup("${zone}::mh_version")
  notice("$mh_version")
 $mh_mobile_version = extlookup("${zone}::mobile_version")
  notice("$mh_mobile_version")
 $mh_xmlmobile_version = extlookup("${zone}::xmlmobile_version")
  notice("$mh_xmlmobile_version")
 $mh_gps_version = extlookup("${zone}::gps_version")
  notice("$mh_gps_version")
}
