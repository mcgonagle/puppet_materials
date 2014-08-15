class ec2::params  {

$ec2_root = "/root/ec2"

$ec2_api_tools = "ec2-api-tools"
$ec2_api_tools_zipped =  "${unzipped_ec2_api_tools}.zip"

$elb = "ElasticLoadBalancing"
$elb_zipped =  "${unzipped_ec2_api_tools}.zip"

$module_url = "puppet:///ec2/"
$file_destination = "$ec2_root"

}#end of class ec2::params
