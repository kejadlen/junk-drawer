#!/usr/bin/env ruby

bases = (3..8).to_a.permutation(5)
nums = '22 61 440 220 366'.split(' ')
nums = '22 136 201 165 222'.split(' ')

bases = (2..7).to_a.permutation(2)
nums = '2112 101110'.split(' ')

bases = (2..6).to_a.permutation(4)
nums = '1000 1000 1000 1000'.split(' ')

nums = '1023 1023 226'.split(' ')
bases = (3..9).to_a.permutation(nums.size)

nums = '42 201 140'.split(' ')
bases = (2..6).to_a.permutation(nums.size)

bases.each do |bases|
  sums = nums.zip(bases).map {|n,b| n.to_i(b) }
  next unless sums[0..1].inject(:+) == sums[2]
  # next unless sums[0] == sums[1]
  p nums.zip(bases)
  p sums
end
