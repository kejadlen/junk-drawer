die = (1..6).to_a

p 100_000.times.each.with_object({}) {|_,h|
  roll = Array.new(4) { die.sample }
  pairs = roll.combination(2)
  sums = pairs.map(&:sum)
  h.merge!(sums.tally) { _2 + _3 } unless sums.include?(7)
}.sort_by(&:last).to_h
