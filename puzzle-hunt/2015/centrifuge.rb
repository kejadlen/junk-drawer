#!/usr/bin/env ruby

require 'set'

require 'pry'

DICT = Set.new(File.read('/usr/share/dict/words').split("\n").map(&:downcase))

items = %w[ hay lard opal pea herb ]

def irv(word, n)
  p word.split(//).map do |i|
    letter = (i.ord + n)
    letter = letter - ?z.ord + ?a.ord if letter > ?z.ord
    letter
  end.to_a
end

items.each do |item|
  puts item
  (1..5).each do |i|
    new_item = irv(item, i)
    puts new_item if DICT.include?(new_item)
  end
end

binding.pry
