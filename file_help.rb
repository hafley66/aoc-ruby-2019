ReadInput = -> (input) {
  File.read(File.join(__dir__, 'inputs', input))
}

ReadCommaInt = ->(input) {
  (ReadInput.call input).split(",").map(&:to_i)
}

ReadNewlineInt = -> (i) {
  (ReadInput.call input).split("\n").map(&:to_i)
}

ReadNewline = -> (i) {
  (ReadInput.call input).split("\n")
}

ReadComma = -> (i) {
  (ReadInput.call input).split(",")
}

