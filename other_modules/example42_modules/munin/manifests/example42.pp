# Class munin::example42
#
# Custom project class for example42 project. Use this to adapt the munin module to your project.
# This class is autoloaded if $my_module == example42 and $my_module_onmodule != yes
# If $my_module_onmodule == yes Puppet tries to autoload example42::munin
# that is:  MODULEPATH/example42/manifests/munin.pp
#
# You can use your custom project class to modify the standard behaviour of munin module
# If you need to override parameters of resources defined in munin class use a syntax like
# class munin::example42 inherits munin {
#     File["munin.conf"] {
#         source => [ "puppet:///munin/munin.conf-$hostname" , "puppet:///munin/munin.conf" ],
#     }
#
# You don't need to use class inheritance if you don't override or redefine resources in munin class
#
# Note that this approach leaves you maximum flexinility on how to manage munin application in your environment
# You can add custom resources and decide how to provide the contents of the configuration files:
# - Via static sourced files ( source => ) according to the naming convention you need
# - Via custom templates ( content => ) or templates joins
# - Via some kind on infile line modification tools, such as Augeas or the Example42's conf define approach
#
class munin::example42 {

}
