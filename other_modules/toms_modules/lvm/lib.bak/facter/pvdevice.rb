#pvdevice.rb
require 'facter'

Facter.add("pvdevice") do
	setcode do
  begin
    Facter.operatingsystem
  rescue
    Facter.loadfacts()
  os = Facter.value("operatingsystem")
 if os == "Linux" {
		%x{/usr/sbin/pvs|grep -v PV|awk '{ print $1 }'}.chomp
	end
 } elsif os == "Darwin" {
  setcode.do 
   pvdevice = "Unknown"
  end
 } 
end
