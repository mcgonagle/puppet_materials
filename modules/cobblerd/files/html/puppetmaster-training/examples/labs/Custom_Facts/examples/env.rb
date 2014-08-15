require 'facter'

ENV.each do |name,var|
  Facter.add("env_#{name}") do
    setcode do
      var
    end
  end
end
