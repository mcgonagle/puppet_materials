#pvfree.rb
require 'facter'
Facter.add("pvfree") do
 if $operatingsystem == "Linux" {
  setcode do
		%x{/usr/sbin/pvs -o pv_free|tail -1}.chomp
  end 
 } elsif $operatingsystem == "Darwin" {
  setcode.do 
   pvdevice = "Unknown"
  end
 } 
end
