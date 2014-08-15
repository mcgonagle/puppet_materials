# orgdomain.rb
require 'facter'

Facter.add("orgdomain") do
        setcode do
                begin
                        Facter.product
                rescue
                        Facter.loadfacts()
                end
        product_var = Facter.value('product')
        result = case product_var
                when "bd" then "bigbearden.com"
                when "dl" then "dlist.com"
                else "manhunt.net"
                end
        result
        end
end
