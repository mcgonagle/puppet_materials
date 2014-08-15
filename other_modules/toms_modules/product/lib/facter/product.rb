# product.rb
require 'facter'

Facter.add("product") do
        setcode do
                begin
                        Facter.hostname
                rescue
                        Facter.loadfacts()
                end

        hostname = Facter.value('hostname')
        if hostname.match(/\w+\w\w\w\w\d+$/)
                product = hostname[/\w\w\w\w\d+$/].tr('0-9','')[0,2]
                product 
        end
        end
end
