import "classes/*/*"

$extlookup_datadir = "/etc/puppet/manifests/classes"
$extlookup_precedence = [ "hosts/%{fqdn}", "roles/role_%{role}", "zones/zone_%{zone}", "products/product_%{product}", "datacenters/datacenter_%{datacenter}", "common/common", "appyml/appyml_%{zone}", "appyml/appyml"]


stage { 'common': before => Stage['main'] }
stage { 'datacenter': require => Stage['common'] }
stage { 'product': require => Stage['datacenter'] }
stage { 'zone': require => Stage['product'] }
stage { 'role': require => Stage['zone'] }
stage { 'host': require => Stage['role'] }

$site_datacenter = inline_template("datacenter::<%= datacenter %>")
$site_product = inline_template("product::<%= product %>")
$site_zone = inline_template("zone::<%= zone %>")
$site_role = inline_template("role::<%= role %>")
$site_host = inline_template("host::<%= hostname %>")

node default {
  class {"common": stage => common}
  class {"cron": stage => common}
  class {"yumrepos": stage => common}
  class {"autofs": stage => common}
  class {"users": stage => common}
  class {"sudo": stage => common}
  class {"ssh": stage => common}
  class {"ntp": stage => common}

  #class { "${site_datacenter}": stage => datacenter}
  #class { "${site_product}": stage => product}
  #class { "${site_zone}": stage => zone}
  class { "${site_role}": stage => role}
  #class { "${site_host}": stage => host}

}#end of default 
