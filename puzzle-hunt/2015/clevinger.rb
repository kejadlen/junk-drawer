#!/usr/bin/env ruby

require 'set'

require 'pry'

DICT = Set.new(File.read('/usr/share/dict/words').split("\n").map(&:downcase))
DICT.select! {|word| word.size == 4 }

trans = Hash[((?a..?z).to_a - [?q]).zip('nxizwrejlgtubpvyacsodfmkh'.split(//))]
inv = trans.invert

DICT.each do |word|
  b = word.split(//).map {|letter| trans[letter] }.join
  next unless DICT.include?(b)
  puts "#{word}, #{b}"
  # puts "#{word} => #{b}"
end

DICT.each do |word|
  b = word.split(//).map {|letter| inv[letter] }.join
  next unless DICT.include?(b)
  puts "#{word}, #{b}"
  # puts "#{word} => #{b}"
end
