# role.rb
require 'facter'

Facter.add("role") do
        setcode do
                begin
                        Facter.hostname
                rescue
                        Facter.loadfacts()
                end

        hostname = Facter.value('hostname')
        if hostname.match(/\w+\w\w\w\w\d*$/)
                role = hostname[/\w+\w\w\w\w\d*$/].tr('0-9','').sub(/\w\w\w\w$/,'')
         	if role.match("www")
                        role = hostname[/\w+\w\w\w\w\d*$/].tr('0-9','').sub(/\w\w$/,'')
                end
                role 
        end
        end
end
