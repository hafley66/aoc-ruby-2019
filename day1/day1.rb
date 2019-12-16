require_relative("../file_help.rb")

def sum_mass(sum, mass)
  (mass = (mass / 3 - 2) ) > 0 ? sum_mass(sum + mass, mass) : sum
end

(
  ReadInput.call("day1.txt").split("\n")
    .map(&:to_i)
    .map(&-> (init) { sum_mass(0, init) })
    .sum
)
