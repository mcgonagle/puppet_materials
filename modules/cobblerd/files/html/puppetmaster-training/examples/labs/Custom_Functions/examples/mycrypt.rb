require "digest/sha1"
module Puppet::Parser::Functions
  newfunction(:mycrypt, :type => :rvalue ) do |args|
    Digest::SHA1.hexdigest(args[0])
  end
end
