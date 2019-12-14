
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

ParseOpCode = -> (op_int) {
  s = op_int.to_s
  op_i = ( s[-2..-1] || s[-1] ).to_i
  modes = s[0...-2]
  [
    op_i,
    (modes.reverse + "00000000000").split("").map(&:to_i)
  ]
}

class IntCodeArray

  attr_reader :outputs
  attr_reader :codes

  def initialize codes, inputs
    @codes = codes
    @init_inputs = inputs
    @inputs = []
    @outputs = []
  end

  def call
    i = 0
    @inputs = @init_inputs.clone
    @outputs = []
    while i = op_code(i);;end
    return @outputs
  end

  def op_code index
    op_i, modes = ParseOpCode.call @codes[index]
    args = @codes[index+1..]

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

  def [] (index, mode=POSITION)
    x = case mode
    when POSITION, nil
      @codes[index]
    when IMMEDIATE
      index
    end
    x
  end

  def arithmetic_op(op_int, (mode_x, mode_y), (x, y, out))
    mode_x ||= POSITION
    mode_y ||= POSITION

    xx = self[x, mode_x]
    yy = self[y, mode_y]
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
    mode ||= POSITION
    case op_int
    when INPUT
      @codes[arg] = @inputs.shift
    when OUTPUT
      @outputs << self[arg, mode]
    end
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

end
