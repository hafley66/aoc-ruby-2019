
ADD = 1
MULTIPLY = 2
INPUT = 3
OUTPUT = 4
JUMP_IF_TRUE = 5
JUMP_IF_FALSE = 6
LESS_THAN = 7
EQUALS = 8

TERMINATE = 99

POSITION = 0
IMMEDIATE = 1

BOOL_FALSE = 0
BOOL_TRUE = 1

Log = ->(it) {
  return
  puts it.to_s
}

class IntCodeArray

  def arithmetic_op(op_int, (mode_x, mode_y), (x, y, out))
    mode_x ||= POSITION
    mode_y ||= POSITION

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

  def jump_op(op_int, (arg_mode, out_mode), (arg, out))
    arg_mode ||= POSITION
    out_mode ||= POSITION
    if self[arg, arg_mode].send(
      case op_int
      when JUMP_IF_FALSE
        :==
      when JUMP_IF_TRUE
        :!=
      end,
      BOOL_FALSE
    )
      self[out, out_mode]
    else
      nil
    end
  end

  def io_op(op_int, (mode), (arg))
    mode ||= POSITION
    case op_int
    when INPUT
      puts "Input OP:"
      @codes[arg] = gets.chomp.to_i
    when OUTPUT
      puts "Output OP:#{self[arg, mode]}"
    end
  end

  def bool_op(op_int, (lhs_mode, rhs_mode), (lhs, rhs, output))
    lhs_mode ||= POSITION
    rhs_mode ||= POSITION

    ll, rr = self[lhs, lhs_mode], self[rhs, rhs_mode]
    @codes[output] = ll.send(
      case op_int
      when LESS_THAN
        :<
      when EQUALS
        :==
      end,
      rr
    ) ? BOOL_TRUE : BOOL_FALSE
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
  end

  def op_code index
    op_i, modes = parse_op_code @codes[index]
    args = @codes[index+1..]

    Log.call ["op_code:", index, op_i, modes.to_s, op_i]

    next_index = (
      case op_i
      when ADD, MULTIPLY
        arithmetic_op op_i, modes, args
        index + 4
      when LESS_THAN, EQUALS
        bool_op op_i, modes, args
        index + 4
      when INPUT, OUTPUT
        io_op op_i, modes, args
        index + 2
      when JUMP_IF_FALSE, JUMP_IF_TRUE
        (jump_op op_i, modes, args) || (index + 3)
      when TERMINATE
        return nil
      else
        raise StandardError.new("Unexpected input!#{index} #{@codes[index]}")
      end
    )

    if next_index < @codes.length
      next_index
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
