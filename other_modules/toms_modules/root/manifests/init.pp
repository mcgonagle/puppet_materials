class root {
  file{"/root/.bashrc":
	source => "puppet:///modules/root/bashrc",
	owner => "root", group => "root", mode => "0644", }
}#end of class root
