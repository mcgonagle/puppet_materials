# orgname.rb
require 'facter'
Facter.add("orgname") do
        setcode do
                begin
                        Facter.product
                rescue
                        Facter.loadfacts()
                end
        product_var = Facter.value('product')
        result = case product_var
                when "bd" then "bigbearden"
                when "dl" then "dlist"
                else "manhunt"
                end
        result
        end
end
