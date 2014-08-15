# Class: users
#
# This module manages users
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class users () inherits users::params {
  include users::it
	  Group <| tag == "it" |> User <| tag == "it" |>

  include users::common
    Group <| tag == "common" |> User <| tag == "common" |> 

	include users::dba
	if $hostname =~ /cobbler/ { 
	  Group <| tag == "dba" |> User <| tag == "dba" |> 
	} elsif $hostname =~ /db/ {
	  Group <| tag == "dba" |> User <| tag == "dba" |> 
	}#end if/elsif

	include users::dev, users::qa
	if $zone =~ /dv/  {
	  Group <| tag == "dev" |> User <| tag == "dev" |> 
	} elsif $zone =~ /qa/ {
	  Group <| tag == "qa" |> User <| tag == "qa" |> 
	}#end of if/elsif
	
}#end of users class
