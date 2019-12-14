# .to_a.permutation(5).to_a
require "./IntCodeArray.rb"
int_codes = File.read("in.txt").split(",").map(&:to_i)
[[4,3,2,1,0]].max_by do |combos|
  combos.reduce(0) do |next_input, amplifier|
    puts "lol wut"
    puts(IntCodeArray.new(int_codes.clone, [amplifier, next_input]).call)
  end
end
