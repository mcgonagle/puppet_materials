# organization.rb
require 'facter'
Facter.add("organization") do
        setcode do
                begin
                        Facter.product
                rescue
                        Facter.loadfacts()
                end
        product_var = Facter.value('product')
        result = case product_var
                when "dl" then "OLB Media Inc."
                else "Online Buddies Inc."
                end
        result
        end
end
