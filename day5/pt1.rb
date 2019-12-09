POSITION = 0
IMMEDIATE = 1
ADD = 1
MULTIPLY = 2
INPUT = 3
OUTPUT = 4

class IntCodeArray

  def arithmetic_op op_int, modes, x, y, out
    x_mode, y_mode = modes
    self[self[out]] = self[x, x_mode].send(
      case op_int
      when ADD
        :+
      when MULTIPLY
        :*
      end,
      self[y, y_mode]
    )
  end

  def io_op op_int, address, inputs, outputs
    case op_int
    when INPUT
      self[address]
    when OUTPUT
      self[address, ]
    end
  end


  def initialize codes, inputs
    @codes = codes
    @inputs = inputs
  end

  def [] (index, mode=POSITION)
    case mode
    when POSITION, nil
      @codes[@codes[index]]
    when IMMEDIATE
      @codes[index]
    end
  end

  def []= (index, mode=position)
    case mode
    when POSITION, nil
      @codes[@codes[index]]
    when IMMEDIATE
      @codes[index]
    end
  end

  def parse_op_code op_int
    s = op_int.to_s
    op_i = s[-2..-1].to_i
    modes = s[0..-2]
    return [
      op_i,
      modes.reverse
    ]
  end

  def run_op index, inputs

  end

  def call
    @index = 0
    i = 0
    push = 0
    while i = op_code(a, i);;end
      a[0]
    end
end

# def op_code array, index, inputs
#   op, a, b, c = array[index...index+4]
#   code, push = case op
#   when 1
#     [:+, 4]
#   when 2
#     [:*, 4]
#   when 3
#     [:<, 1]
#   when 4
#     [:>, 1]
#   when 99
#     return nil
#   else
#     raise StandardError.new("Unexpected input!"+ ({ index: index, op: op, a: a, b: b, c: c}).to_s)
#   end
#
#
#   array[c] = array[a].send(code, array[b])
#   if (index = (index + push)) < array.length
#     index
#   else
#     nil
#   end
# end



def run_ops a
  i = 0
  push = 0
  while i = op_code(a, i);;end
  a[0]
end

def init_intcode a, n, v
  b = [*a]
  b[1] = n
  b[2] = v
  b
end

def main array, target
  realm = (realm = [*(0..99)]).product realm
  realm.find_all do |(n, v)|
    x = run_ops(
      init_intcode(array, n, v)
    ) rescue false
    puts({x:x, n:n, v:v}.to_s) if x <= target
    x == target
  end
end

puts (
  main(
    File.read("in.txt").split(",").map(&:to_i),
    19690720
  ).to_s
)


A = Struct.new() do
  def []=(a,b,c,val)
    puts (a,b,c,val)
  end
end



a = A.new
a[1,2,3] = 4
