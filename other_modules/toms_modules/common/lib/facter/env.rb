require 'facter'

ENV.each do |name,var|
  next if name == "LS_COLORS"
  next if name == "_"
  Facter.add("env_#{name.downcase}") do
    setcode do
      var
    end
  end
end
