# class mcollective::plugin
# 
# Installs plugins for mcollective
# The sources are based on http://github.com/ripienaar/mcollective-plugins.git
# 
# Usage:
# include mcollective::plugin

import "plugins/*.pp"

class mcollective::plugin inherits mcollective {

 include mcollective::plugin::facter
 include mcollective::plugin::service

}
