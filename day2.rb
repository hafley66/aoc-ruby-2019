def op_code (array, index)
  op, a, b, c = array[index...index+4]
  code = case op
  when 1
    :+
  when 2
    :*
  else
    raise Exception.new("Unexpected input!")
  end

  array[c] = array[a].send(code, array[b])
end

a = File.read("2.txt").split(",").map(&:to_i)
i = 0
while i < a.length && a[i] != 99
  op_code(a, i)
  i+=4
end
puts(a[0])
