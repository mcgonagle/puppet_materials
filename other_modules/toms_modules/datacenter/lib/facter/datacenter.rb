# datacenter.rb
require 'facter'

Facter.add("datacenter") do
        setcode do
		begin
			Facter.domain
		rescue
			Facter.loadfacts()
		end
	domain_var = Facter.value('domain')
	result = case domain_var
   		when "qa.manhunt.net" then "cambridge"
   		when "dev.manhunt.net" then "cambridge"
   		when "cambridge.manhunt.net" then "cambridge"
   		when "cam.manhunt.net" then "cambridge"
   		when "manhunt.local" then "cambridge"
   		when "somerville.manhunt.net" then "somerville"
   		when "waltham.manhunt.net" then "waltham"
   		when "wal.manhunt.net" then "waltham"
		else "Unknown"
		end
	result
        end
end
