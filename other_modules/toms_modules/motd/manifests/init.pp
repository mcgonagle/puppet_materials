# Class: motd
#
# Manages motd software 
# Include it to install and run motd with default settings
#
# Usage:
# include motd


#import "classes/*.pp"
#import "defines/*.pp"

class motd {
    file {"/etc/motd":
      content => inline_template("
########################################################################
#TAGS
########################################################################
<% all_tags.each do |tag| -%> <%= tag %> defined <% end -%>"),
      owner => "root", group => "root", mode => "0755",}

}#end of class motd
