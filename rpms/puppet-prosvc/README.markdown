# Overview

This is an unofficial repository primarily used by the Puppet Labs Professional
Services team for prototyping new Puppet Modules.

If this repository is used, we recommend you use some tool like Cobbler,
Satellite or rsync to maintain a local copy of this repository.  The contents
may change unexpectedly and if you need a previous version of a package, it
will serve you well to have a local cache.

# Digital Signatures

All packages are signed against the Puppet Labs ProSvc key.  This key should be
imported to verify the authenticity of the software hosted in this repository.

# Upstream Repositories

The following resources are used as upstream repositories for the software
hosted in this repository.

 * [EPEL](http://download.fedora.redhat.com/pub/epel/)
 * [RabbitMQ](http://www.rabbitmq.com/releases/rabbitmq-server/)
 * [TMZ Puppet](http://people.fedoraproject.org/~tmz/repo/puppet/epel/)

And custom built packages exist as well, e.g. Puppet, etc...

# Tips

## Clean just the prosvc cache

    sudo yum --disablerepo='*' --enablerepo=prosvc clean all

## Move the repository around

Take a look at the sync scripts located in the root of the repository if you're
working on building and publishing packages.  These help me move the entire
package tree from my Enterprise Linux Vagrant box into my local Yum repository
on my laptop for testing, then to the central prosvc repository published to
the internet.
