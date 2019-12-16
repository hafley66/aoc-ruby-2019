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
    raise StandardError.new("Unexpected input!")
  end

  array[c] = array[a].send(code, array[b])
  if (index = (index + push)) < array.length
    index
  else
    nil
  end
end

a = File.read("2-o.txt").split(",").map(&:to_i)

def run a
  i = 0
  push = 0
  while i = op_code(a, i);;end
  a[0]
end

puts(run(a))
