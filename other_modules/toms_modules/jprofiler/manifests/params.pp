class jprofiler::params  {

# Basic settings
$packagename = $operatingsystem ? {
    default => "jprofiler_linux_5_1_4.rpm",
}

$file_destination = $operatingsystem ? {
    default => "/var/lib/puppet/scratch",
}

$file_url = $operatingsystem ? {
    default => "puppet:///modules/jprofiler/",
}

$config_xml = "/opt/jprofiler5/config/config.xml"


}#end of class jprofiler::params
