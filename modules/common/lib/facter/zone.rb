# zone.rb
require 'facter'

Facter.add("zone") do
        setcode do
                begin
                        Facter.hostname
                rescue
                        Facter.loadfacts()
                end

        hostname = Facter.value('hostname')
	if hostname.match("cobbler")
		zone = "it"
		zone
        elsif hostname.match(/\w+\w\w\w\w\d*$/)
                zone = hostname[/\w\w\d*$/].tr('0-9','')
                zone 
        end
        end
end
