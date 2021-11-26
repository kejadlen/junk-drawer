require 'letters'
require 'pry'

words = File.read('/usr/share/dict/words').split("\n")

valid = words.select {|w| w.size > 5 }

foo = valid.select { |w|
  w =~ /apocal/
}.o

# binding.pry
