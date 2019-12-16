require_relative("../file_help.rb")
require_relative("../IntCode/IntCodeArray.rb")

c = File.read("in.txt").split(",").map(&:to_i)
p = IntCodeArray.new(
  ReadCommaInt.call("day5.txt"),
  [5]
)
puts p.call
