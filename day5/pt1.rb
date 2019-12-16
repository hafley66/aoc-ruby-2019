require_relative("../IntCode/IntCodeArray.rb")
c = File.read("in.txt").split(",").map(&:to_i)
p = IntCodeArray.new(
  c,
  [1]
)
puts p.call
