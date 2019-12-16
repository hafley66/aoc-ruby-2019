require_relative("./IntCodeArray.rb")
require_relative("../file_help.rb")

FromFile = ->(file_name, inputs=[]) {
  ::IntCodeArray::ArrayIORunner.new(
    (ReadCommaInt.call file_name),
    inputs: inputs
  )
}

RSpec.describe IntCodeArray do
  it "passes day 2 in.txt" do
    x = FromFile.call("day2.txt")
    x.call
    expect(
      x.codes[0]
    ).to be(10566835)
  end

  it "passes day5 part1" do
    x = FromFile.call("day5.txt", [1])
    x.call
    expect(
      x.outputs.last
    ).to be(15097178)
  end

  it "passes day5 part2" do
    x = FromFile.call("day5.txt", [5])
    x.call
    expect(
      x.outputs.last
    ).to be(1558663)
  end

end
