# nfs_home_server.rb
require 'facter'

Facter.add("nfs_home_server") do
        setcode do
		begin
			Facter.hostname
		rescue
			Facter.loadfacts()
		end
	hostname_var = Facter.value('hostname')
	result = "lrmedia01.qa.manhunt.net"
	result
   end
end
