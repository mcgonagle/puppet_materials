current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "mcgonagletom"
client_key               "#{current_dir}/mcgonagletom.pem"
validation_client_name   "lr-validator"
validation_key           "#{current_dir}/lr-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/lr"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
