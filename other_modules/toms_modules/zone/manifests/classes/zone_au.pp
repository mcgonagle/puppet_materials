class zone::au inherits zone {
        include users
	search("users")
	include users::au_users
}#end of zone::au
