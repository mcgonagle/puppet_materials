# hostid.rb
require 'facter'

Facter.add("hostid") do
        setcode do
                begin
                        Facter.hostname
                rescue
                        Facter.loadfacts()
                end

        hostname = Facter.value('hostname')
        if hostname.match(/\w+\w\w\w\w\d+$/)
                hostid = hostname[/\w+\w\w\w\w\d+$/].tr('a-z','').tr('A-Z','')
                hostid 
	else hostid = "undef"
	     hostid
        end
        end
end

