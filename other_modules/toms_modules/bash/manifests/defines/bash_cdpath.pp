define bash::cdpath_append(
$path
) {
 file{"/etc/profile.d/${name}.sh":
	content => "#!/bin/bash
export CDPATH=${CDPATH}:${path}
",
owner => "root", group => "root", mode => "0755", }
}#end of bash::cdpath_append
