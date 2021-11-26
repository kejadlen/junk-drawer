def xor(one, two)
  (one or two) and not (one and two)
end

one = true
two = true

a = !xor(one, two)
b = xor(one, two)
c = (one and two)
d = !(one and two)

puts [d, (c or d), d, b, (a or b), !one, a]
