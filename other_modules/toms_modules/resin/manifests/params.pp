class resin::params  {
# Basic settings
$untared_packagename = $role ? {
    #default => "resin-pro-4.0.18",
    default => "resin-pro-3.1.11",
}

$packagename = $operatingsystem ? {
    default => "${untared_packagename}.tar.gz",
}

$file_url = $operatingsystem ? {
    default => "puppet:///modules/resin/",
}

$file_destination = $operatingsystem ? {
    default => "/opt",
}

}#end of class resin::params
