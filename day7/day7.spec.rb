require_relative("./pt1.rb")
require "./file_help.rb"

IntCodes = ReadCommaInt.call "day7.txt"

RSpec.describe "day7" do
  Permutations = (0..4).to_a
  it "finds max signal and tuple that found it from examples" do
    expect(
      FindMaxSignal.call(
        [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0],
        Permutations
      )
    ).to eq([
      [4,3,2,1,0],
      43210
    ])
  end

  it "finds max amplifier signal tuple from main problem" do
    expect(
      FindMaxSignal.call(
        IntCodes,
        Permutations
      )
    ).to eq([
      [2, 0, 1, 4, 3],
      19650
    ])
  end
end

# RSpec.describe "day7 part 2" do
#   Permutations = (5..9).to_a
#   it "passes example programs" do
#     expect(
#       FindMaxSignal.call(phase_settings_domain: Permutations)
#   end
# end
