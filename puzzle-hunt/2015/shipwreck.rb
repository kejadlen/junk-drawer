#!/usr/bin/env ruby
require 'set'

require 'pry'

DICT = Set.new(File.read('/usr/share/dict/words').split("\n").map(&:downcase))

lines = <<LINES.chomp.split("\n")
dc
rum
ahoy
yacht
league
admiral
helmsman
LINES

words = lines.shift.split(//)
while letters = lines.shift
  letters = letters.split(//)
  words = words.flat_map do |word|
    letters.map do |letter|
      word + letter
    end
  end
  gets
end
puts words.select {|word| DICT.include?(word) }
