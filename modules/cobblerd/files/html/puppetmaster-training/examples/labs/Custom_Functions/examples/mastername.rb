# mastername.rb
require 'socket'
module Puppet::Parser::Functions
  newfunction(:mastername, :type => :rvalue ) do
    Socket.gethostname.chomp
  end
end
