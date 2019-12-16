require "./IntCode/IntCodeArray.rb"

FindMaxSignal = -> (int_codes, permutation_set) {
  permutation_set.permutation(5).to_a.map { |combos|
    [
      combos,
      combos.reduce(0) do |next_input, amplifier|
        out = ::IntCodeArray::ArrayIORunner.new(
          int_codes.clone,
          inputs: [amplifier, next_input]
        ).call
        out.last
      end
    ]
  }.max_by { |(combo, signal)| signal }
}
