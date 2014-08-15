#!/usr/bin/ruby
#
# $Id: check_build.rb,v 1.5 2010/10/13 14:45:58 apradhan Exp $
#
# This script checks the version of the manhunt code deployed on the servers
#

require 'open-uri'
require 'rubygems'
require 'colorize'
@hosts = [ 
           "www01.v4",
           "www02.v4",
           "www03.v4",
           "www04.v4",
           "www05.v4",
           "www06.v4",
           "www07.v4",
           "www08.v4",
           "www09.v4",
           "www10.v4",
           "www11.v4",
           "www12.v4",
           "www13.v4",
           "www14.v4",
           "www15.v4",
           "www16.v4",
           "www17.v4",
           "www18.v4",
           "www19.v4",
           "www20.v4",
           "www21.v4",
           "www22.v4",
           "www23.v4",
           "www24.v4",
           "www25.v4",
           "www26.v4",
           "www27.v4",
           "www28.v4",
           "www29.v4",
           "www30.v4",
           "www31",
           "www32"
         ]

@hostname

def check_version
  @hosts.each do |host|
    url="http://#{host}.waltham.manhunt.net/debuginfobasic.php"
    @hostname = host

    begin
      open(url) do |f|
        html = f.read
        version = html.grep(/mhbangv4.version/).to_s.gsub!(/<\/li><li>mhbangv4.version=/,'')
        puts host.gsub(/\.v4/, '') +" has " +version
      end
    rescue
      message = @hostname + " doesn't look up"
      puts message.colorize( :red )
    end
 
  end
end
puts "\n\n\n\nThese servers have the following builds:\n\n".colorize( :green )
check_version
