# Class mcollective::example42::server
#
# Custom project class for example42 project. Use this to adapt the mcollective  module to your project.
# This class is autoloaded if $my_module == example42 and $my_module_onmodule != yes
# If $my_module_onmodule == yes Puppet tries to autoload example42::mcollective
# that is:  MODULEPATH/example42/manifests/mcollective.pp
#
# You can use your custom project class to modify the standard behaviour of mcollective module
# If you need to override parameters of resources defined in mcollective class use a syntax like
# class mcollective::example42 inherits mcollective {
#     File["mcollective.conf"] {
#         source => [ "puppet:///mcollective/mcollective.conf-$hostname" , "puppet:///mcollective/mcollective.conf" ],
#     }
#
# You don't need to use class inheritance if you don't override or redefine resources in mcollective class
#
# Note that this approach leaves you maximum flexinility on how to manage mcollective application in your environment
# You can add custom resources and decide how to provide the contents of the configuration files:
# - Via static sourced files ( source => ) according to the naming convention you need
# - Via custom templates ( content => ) or templates joins
# - Via some kind on infile line modification tools, such as Augeas or the Example42's conf define approach
#
class mcollective::example42::server {

}
