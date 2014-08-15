class ganglia::midtier inherits ganglia {

package { rrdtool-devel: ensure => latest }
package { ganglia-gmetad: ensure => latest }

service { "gmetad":
  enable => true, 
  ensure => running,
  subscribe => File["/etc/ganglia/gmetad.conf"],
}


ganglia_config_def{"gmond":
			template_name   => "gmond.conf",
			subscribe       => Package[ganglia-gmond],
			before 		=> Service[gmond],
			notify 		=> Service[gmond],
			}

ganglia_config_def{"gmetad":
			template_name   => "gmetad.conf",
			subscribe       => Package[ganglia-gmetad], 
			before 		=> Service[gmetad],
			notify 		=> Service[gmetad],
			}

}#end of ganglia midtier

