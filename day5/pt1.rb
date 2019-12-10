POSITION = 0
IMMEDIATE = 1
ADD = 1
MULTIPLY = 2
INPUT = 3
OUTPUT = 4

Log = ->(it) {
  return
  puts it.to_s
}

class IntCodeArray

  def arithmetic_op(op_int, (mode_x, mode_y), (x, y, out))
    mode_x ||= 0
    mode_y ||= 0

    Log.call ["arithmetic_op", {
      op_int: op_int,
      mode_x: mode_x,
      mode_y: mode_y,
      x: x,
      y: y,
      out: out
    }]

    xx = self[x, mode_x]
    yy = self[y, mode_y]
    Log.call ["a2", xx, yy]
    @codes[out] = xx.send(
    case op_int
      when ADD
        :+
      when MULTIPLY
        :*
      end,
      yy
    )
  end

  def io_op(op_int, (mode), (arg))
    mode ||= 0
    case op_int
    when INPUT
      puts "Input OP:"
      @codes[arg] = gets.chomp.to_i
    when OUTPUT
      puts "Output OP:#{self[arg, mode]}"
    end
  end

  def initialize codes
    @codes = codes
  end

  def [] (index, mode=POSITION)
    x = case mode
    when POSITION, nil
      @codes[index]
    when IMMEDIATE
      index
    end
    Log.call ["[]", index, mode, x]
    x
  end

  def parse_op_code op_int
    s = op_int.to_s
    op_i = ( s[-2..-1] || s[-1] ).to_i
    modes = s[0...-2]
    Log.call ["parse", op_int, s, op_i, modes]
    return [
      op_i,
      (modes.reverse + "00000000000").split("").map(&:to_i)
    ]
  end

  def call
    i = 0
    while i = op_code(i);;end
    @codes[0]
  end

  def op_code index
    op_i, modes = parse_op_code @codes[index]
    args = @codes[index+1..]

    Log.call ["op_code:", index, op_i, modes.to_s, op_i]

    push = case op_i
    when ADD, MULTIPLY
      arithmetic_op op_i, modes, args
      4
    when INPUT, OUTPUT
      io_op op_i, modes, args
      2
    when 99
      return nil
    else
      raise StandardError.new("Unexpected input!#{index} #{@codes[index]}")
    end

    if (index = (index + push)) < @codes.length
      index
    else
      nil
    end
  end
end
c = File.read("in.txt").split(",").map(&:to_i)
p = IntCodeArray.new(
  c
)
puts p.call
