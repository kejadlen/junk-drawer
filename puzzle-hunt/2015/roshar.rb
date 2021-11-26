#!/usr/bin/env ruby

require 'set'

require 'pry'

DICT = Set.new(File.read('/usr/share/dict/words').split("\n").map(&:downcase))

roshar = <<ROSHAR.chomp.split("\n").map {|i| i.split(//) }
N O S A A O I I N4 O
S I I R B N T L L I
N E O O H E A M U T
D T N C I S N I M A
I A R T O S E H R O
V N T I N O G D A F
I S A O N N R T R S
S P T T I V A N A N
I O R A T R O O I S
O N N O I P G R E S
ROSHAR

def roshar.words(x, y)
  dirs = (1..3).map do |i|
    [[0,i], [0,-i], [i,0], [-i,0],
     [i,i], [i,-i], [-i,i], [-i,-i]]
  end
  dirs = (0..7).map {|i| [[0,0]].concat(dirs.map {|x| x[i] }) }

  words = dirs.map do |dir|
    word = dir.map do |xx,yy|
      next unless (0..19).cover?(x+xx) && (0..19).cover?(y+yy)
      self[x+xx][y+yy]
    end.join
  end.select {|word| word.size == 4 && DICT.include?(word.downcase) }
end

all = []
milo.size.times do |x|
  milo[x].size.times do |y|
    words = milo.words(x,y)
    next if words.empty?
    puts "(#{x},#{y}): #{words.join(', ')}"
    all.concat(words)
  end
end
puts all.sort

def all.ring(word)
  word.size.times do |i|
    r = word.dup
    r[i] = '.'
    poss = self.grep(Regexp.new(r)).reject {|w| w == word }
    puts poss unless poss.empty?
  end
end

binding.pry
