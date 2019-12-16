require "./IntCode/IntCodeArray.rb"

FindMaxSignal = -> (int_codes, permutations) {
  permutations.map { |combos|
    [
      combos,
      combos.reduce(0) do |next_input, amplifier|
        out = IntCodeArray.new(int_codes.clone, [amplifier, next_input]).call
        out.last
      end
    ]
  }.max_by { |(combo, signal)| signal }
}
