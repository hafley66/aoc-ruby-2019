require_relative("./pt1.rb")
require "./file_help.rb"

IntCodes = ReadCommaInt.call "day7.txt"

RSpec.describe "day7" do
  Permutations = (0..4).to_a
  # it "finds max signal and tuple that found it from examples" do
  #   expect(
  #     FindMaxSignal.call(
  #       [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0],
  #       Permutations
  #     )
  #   ).to eq([
  #     [4,3,2,1,0],
  #     43210
  #   ])
  # end

  # it "finds max amplifier signal tuple from main problem" do
  #   expect(
  #     FindMaxSignal.call(
  #       IntCodes,
  #       Permutations
  #     )
  #   ).to eq([
  #     [2, 0, 1, 4, 3],
  #     19650
  #   ])
  # end
end

RSpec.describe "day7 part 2" do
  it "passes example programs" do
    # p = (0..5).to_a.permutation(5).to_a
    p = [[9, 8, 7, 6, 5], [5, 6, 7, 8, 9]]
    expect(
      (FindMaxFeedbackSignal.new).call(
        [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
        27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5],
        p
      )
    ).to eq([
      [9,8,7,6,5],
      139629729
    ])
  end
end
