class modprobe {
 case $productname {
	/PowerEdge R[6,7]10/: { notice("$productname") 
		augeas {"/etc/modprobe.conf bnx":
			context => "/files/etc/modprobe.conf",
			changes => ["set options[last()+1] bnx2",
				    "set options[last()+1]/bnx2 disable_msi=1"] }
	}
	default:	{ }
 }#end of case statement
}#end of modprobe
