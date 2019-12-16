

class IntCodeArray
  ParseOpCode = -> (op_int) {
    s = op_int.to_s
    op_i = ( s[-2..-1] || s[-1] ).to_i
    modes = s[0...-2]
    [
      op_i,
      (modes.reverse + "00000000000").split("").map(&:to_i)
    ]
  }

  ARITHMETIC_ARG_COUNT = 4
  BOOLEAN_ARG_COUNT = 4
  IO_ARG_COUNT = 2
  JUMP_ARG_COUNT = 3

  ADD = 1
  MULTIPLY = 2
  INPUT = 3
  OUTPUT = 4
  JUMP_IF_TRUE = 5
  JUMP_IF_FALSE = 6
  LESS_THAN = 7
  EQUALS = 8

  TERMINATE = 99
  TERMINATE_INDEX = nil

  POSITION = 0
  IMMEDIATE = 1

  BOOL_FALSE = 0
  BOOL_TRUE = 1

  Log = lambda {|x|
    return
    puts x.to_s if x
  }

  attr_reader :codes, :index

  def initialize(codes = [], on_input: Log, on_output: Log, on_terminate: Log)
    self.index = 0
    @codes = codes
    @on_input = on_input
    @on_output = on_output
    @on_terminate = on_terminate
  end

  def index= val
    puts "cyring in my sleep #{val}"
    @index = val
  end

  def call(&block)
    while !(run_op_code(&block).nil?)
    end
    return self
  end

  def _get_proc(name)
    name = name.to_sym
    if self.respond_to?(name)
      self.method(name)
    elsif (as_instance_var_proc = self.instance_variable_get(("@"+name.to_s).to_sym))
      as_instance_var_proc
    end
  end

  def run_op_code
    op_i, modes = ParseOpCode.call @codes[index]
    args = @codes[index+1..]
    i = index

    yield(
      is_before_op: true,
      is_after_op: false,
      op_i: op_i,
      modes: modes,
      args: args,
      index: index,
      next_index: nil
    ) if block_given?

    self.index = (
      case op_i
        when ADD, MULTIPLY
          (arithmetic_op op_i, modes, args)
          i + ARITHMETIC_ARG_COUNT
        when LESS_THAN, EQUALS
          (bool_op op_i, modes, args)
          i + BOOLEAN_ARG_COUNT
        when INPUT, OUTPUT
          (io_op op_i, modes, args)
          i + IO_ARG_COUNT
        when JUMP_IF_FALSE, JUMP_IF_TRUE
          (jump_op op_i, modes, args) || (i + JUMP_ARG_COUNT)
        when TERMINATE
          (_get_proc :on_terminate).call(self)
          TERMINATE_INDEX
        else
          raise StandardError.new("Unexpected input!#{i} #{@codes[i]}")
      end
    )

    if index && (index >= @codes.length)
      raise StandardError.new("Unexpected out of bounds!#{@index} #{@codes[@index]}")
    end

    yield(
      is_before_op: false,
      is_after_op: true,
      op_i: op_i,
      modes: modes,
      args: args,
      index: i,
      next_index: index
    ) if block_given?

    index
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
      @codes[arg] = (self._get_proc :on_input).call(self)
    when OUTPUT
      (_get_proc :on_output).call(self, self[arg, mode])
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

  def terminated?
    index == nil
  end

  class ArrayIORunner
    def initialize(codes = [], inputs: [], **kwargs)
      @init_inputs = inputs
      @inputs = []
      @outputs = []
      @int_coder = ::IntCodeArray.new(
        codes.clone,
        on_input: (method :on_input),
        on_output: (method :on_output),
        on_terminate: (method :on_terminate)
      )
    end

    attr_reader :outputs, :inputs, :int_coder

    def codes
      @int_coder.codes
    end

    def call
      @inputs = @init_inputs.clone
      @outputs = []
      @int_coder.call
      @outputs
    end

    def on_input _
      # Hah, this slices, assigns as side effect, hilarious
      (next_input, *@inputs = @inputs)[0]
    end

    def on_output int_code_array, output
      @outputs << output
    end

    def on_terminate _
    end
  end

end



class LinkedList
  attr_reader :head

  def initialize(circular: false)
    @circular = circular
    @head = nil
    @tail = nil
  end

  def append(value)
    if @head
      tail = Node.new(value)
      @tail.next = tail
      if @circular
        tail.next = @head
        @tail = tail
      end
    else
      @head = Node.new(value)
      @tail = @head
    end
  end

  def iterate
    if !@head
      return []
    end
    tmp = []

    node = @head
    clamp = false
    while (node && !(node == @head && clamp))
      clamp = true
      tmp << node
      node = node.next
    end
    tmp
  end

  def iterate_values
    iterate.map{|it| it.value}
  end

  def find(&block)
    iterate.find(&block)
  end

  def print
    iterate.each {|it| puts it.to_s}
  end

  def print_values
    iterate_values { |i| puts i }
  end

  class << self
    def from_array array, **args
      ll = LinkedList.new(**args)
      array.each do |it|
        ll.append it
      end
      ll
    end
  end
end

class Node
  attr_accessor :next
  attr_reader   :value
  def initialize(value)
    @value = value
    @next  = nil
  end
  def to_s
    "Node with value: #{@value}"
  end
end
