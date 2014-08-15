# ntpserver.rb
require 'facter'

Facter.add("ntpserver") do
        setcode do
		begin
			Facter.domain
		rescue
			Facter.loadfacts()
		end
	domain_var = Facter.value('domain')
	result = case domain_var
   		when /wal/i then "dick.waltham.manhunt.net"
   		when /cam/i then "dick.cambridge.manhunt.net"
   		when /som/i then "dick.som.manhunt.net"
   		when /dev/i then "dick.cambridge.manhunt.net"
   		when /qa/i then "dick.cambridge.manhunt.net"
   		when /lr/i then "dick.cambridge.manhunt.net"
		else "Unknown"
		end
	result
        end
end
