#
# yum module
#
# Copyright 2008, admin(at)immerda.ch
# Copyright 2008, Puzzle ITC GmbH
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute
# it and/or modify it under the terms of the GNU
# General Public License version 3 as published by
# the Free Software Foundation.
#
# Apapted for Example42 by Alessandro Franceschi
#
class yum {

    include yum::params

# We Manage Yum for Centos/RedHat only
case $operatingsystem {
    centos: {
        include yum::repo::centos

        if $yum::params::update == "cron" { include yum::cron }
        if $yum::params::update == "updatesd" { include yum::updatesd }

        if $yum::params::extrarepo =~ /centos-testing/ { include yum::repo::centos_testing }
        if $yum::params::extrarepo =~ /epel/ { include yum::repo::epel }
        if $yum::params::extrarepo =~ /rpmforge/ { include yum::repo::rpmforge }
        if $yum::params::extrarepo =~ /karan/ { include yum::repo::karan }
        if $yum::params::extrarepo =~ /jpackage/ { include yum::repo::jpackage }
        if $yum::params::extrarepo =~ /remi/ { include yum::repo::remi }
        if $yum::params::extrarepo =~ /tmz/ { include yum::repo::tmz }
        if $yum::params::extrarepo =~ /puppetlabs/ { include yum::repo::puppetlabs }

        if $my_project { 
            case $my_project_onmodule {
                yes,true: { include "${my_project}::yum" }
                default: { include "yum::${my_project}" }
            }
        }

    }
    redhat: {
        if $yum::params::update == "cron" { include yum::cron }
        if $yum::params::update == "updatesd" { include yum::updatesd }

        if $yum::params::extrarepo =~ /epel/ { include yum::repo::epel }
        if $yum::params::extrarepo =~ /rpmforge/ { include yum::repo::rpmforge }
        if $yum::params::extrarepo =~ /jpackage/ { include yum::repo::jpackage }
        if $yum::params::extrarepo =~ /remi/ { include yum::repo::remi }
        if $yum::params::extrarepo =~ /tmz/ { include yum::repo::tmz }
        if $yum::params::extrarepo =~ /puppetlabs/ { include yum::repo::puppetlabs }

        if $my_project {
            case $my_project_onmodule {
                yes,true: { include "${my_project}::yum" }
                default: { include "yum::${my_project}" }
            }
        }

    }

    default: { fail("no managed repo yet for this distro") }
}

}
