class scribe::midtier inherits scribe {


scribe::scribe_config_template{"scribed":
			template_name   => "scribed_client_conf.erb",
			self_port	=> "1463",
			next_host       => "scribeagg10.athenahealth.com",
			next_host_port  => "1463",
		      }

}



