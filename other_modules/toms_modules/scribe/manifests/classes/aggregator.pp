class scribe::aggregator inherits scribe {

    file { ["${scribe::params::file_path}","${scribe::params::agg_primary_file_path}","${scribe::params::agg_secondary_file_path}"]:
                ensure  => directory,
                owner   => "root",
                group   => "root",
                mode    => 0644,
                before  => File["/etc/scribed/scribed.conf"],
        }#end of file path creation statement

	file { "/etc/scribed/scribed.conf":
		source => "puppet:///modules/scribe/scribed_aggregator.conf",
		owner => "root", group => "root", mode  => 0644,
	}
}



