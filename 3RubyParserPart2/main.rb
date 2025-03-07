load "TinyParser.rb"

parse = Parser.new("input6.tiny")
mytree = parse.program()
puts mytree.toStringList()
