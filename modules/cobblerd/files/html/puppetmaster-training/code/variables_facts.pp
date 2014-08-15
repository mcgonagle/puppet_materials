$foo_dir = "/etc/foo.d"

File { owner => "root", group => "root", mode => "0644" }

file {
  "${foo_dir}":
    ensure  => directory;
  "${foo_dir}/bar.conf":
    content => "My hostname is $hostname";
}
