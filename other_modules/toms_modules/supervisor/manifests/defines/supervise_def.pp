define supervise_def($log_category,
     $log_file,
     $log_host = "localhost",
     $log_port = "1465",
     $log_prefix = "${hostname}",
     $ensure = "present") {

     $line1 = "'[program:scribe.'${log_category}']'"
     $line2 = '\\n'
     $line3 = "command=/usr/local/bin/scribe_log --category ${log_category} --file=${log_file} --host=${log_host} --port=${log_port} --prefix=${log_prefix}"

     case $ensure {
     default: { err ("unknown ensure value ${ensure}")}
     present: {
      exec { "/bin/echo -e ${line1} ${line2}${line3} >> /etc/supervisord.conf":
       ##unless => "/bin/grep -qFx ${line3} /etc/supervisord.conf"
       unless => "! /bin/grep -q ${line3} /etc/supervisord.conf"
       }
     }
     absent: {
      exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${line2}\\E$/' /etc/supervisord.conf":
       onlyif => "/bin/grep -qFx ${line} /etc/supervisord.conf"
       }
     }
    }

  }#end of supervise_definition
