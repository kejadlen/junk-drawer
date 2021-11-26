#!/usr/bin/env ruby

require 'set'

DICT = Set.new(File.read('/usr/share/dict/words').split("\n").map(&:downcase).select {|word| word.size == 7 })

letters = 'tgxpnk'.split(//)
letters.permutation.each do |poss|
  (0..25).each do |i|
    word = poss.map {|letter| (((letter.ord - ?a.ord + i) % 26) + ?a.ord).chr }.join
    p word if DICT.include?(word)
  end
end
