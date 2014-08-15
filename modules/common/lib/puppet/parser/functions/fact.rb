#
# fact.rb
#

module Puppet::Parser::Functions
  newfunction(:fact, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "fact(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    fact = arguments[0]

    unless fact.is_a?(String)
      raise(Puppet::ParseError, 'fact(): Requires fact name to be a string')
    end

    raise(Puppet::ParseError, 'fact(): You must provide ' +
      'fact name') if fact.empty?

    result = lookupvar(fact) # Get the value of interest from Facter ...

    #
    # Now this is a funny one ...  Puppet does not have a concept of
    # returning neither undef nor nil back for use within the Puppet DSL
    # and empty string is as closest to actual undef as you we can get
    # at this point in time ...
    #
    result = result.empty? ? '' : result

    return result
  end
end

# vim: set ts=2 sw=2 et :
