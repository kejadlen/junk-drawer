def f(a, b)
  (0...b.size**a.size)
    .map {|i| i.to_s(b.size).rjust(b.size + 1, ?0).chars.map(&:to_i).map {|j| b.fetch(j) }}
    .map { a.zip(_1) }
end

pp f((1..3).to_a, (?a..?b).to_a)
# pp f((1..4).to_a, (?a..?c).to_a)
