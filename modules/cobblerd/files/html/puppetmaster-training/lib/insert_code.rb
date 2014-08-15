def insert_code(filename)
  File.open("code/#{filename}", 'r').read.chomp
end
