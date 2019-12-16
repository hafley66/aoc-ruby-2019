require_relative("../file_help.rb")

def op_code (array, index)
  op, a, b, c = array[index...index+4]
  code, push = case op
  when 1
    [:+, 4]
  when 2
    [:*, 4]
  when 99
    return nil
  else
    raise StandardError.new("Unexpected input!"+ ({ index: index, op: op, a: a, b: b, c: c}).to_s)
  end

  array[c] = array[a].send(code, array[b])
  if (index = (index + push)) < array.length
    index
  else
    nil
  end
end

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
    ReadCommaInt.call("day2.txt"),
    19690720
  ).to_s
)

puts(
  run_ops(
    ReadCommaInt.call("day2.txt"),
  )
)
