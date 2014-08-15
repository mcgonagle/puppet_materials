module Puppet::Parser::Functions
  # We need to iterate over the block of arguments.
  newfunction(:echo, :type => :rvalue ) do |args|
    # We now have access to the args provided to the function.
    # args[0] is simply the first argument.
    args[0]
  end
end
