require 'facter'
ENV.each do |key, val|
  Facter.add("env_#{key.downcase}") do
    setcode do
      val
    end
  end
end
