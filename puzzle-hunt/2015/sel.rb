#!/usr/bin/env ruby

require 'set'

require 'pry'

sel = <<SEL.downcase.chomp.split("\n").map {|i| i.split(' ') }
N S P Y V A G R R X
O S U V L F S E T S
I S F F O N T X U C
N H G F S F D U U S
I A K F Z B K Z X H
M O B M J O Z Z K A
O D V H Q R Y W K R
D N B A G E S D Y D
G R G A N N D N E X
X H N B V G B I E D
SEL

magics = <<MAGICS.chomp.split("\n")
aondor
chayshan
dakhor
devotion
dominion
resealing
seons
shaod
shard
skaze
splinter
MAGICS

def words(puzzle, x, y, n)
  n = n - 1
  ends = [[0,n], [0,-n], [n,0], [-n,0],
          [n,n], [n,-n], [-n,n], [-n,-n]]
  ends = ends.map do |xx, yy|
    next unless (0..puzzle.size).cover?(x+xx) && (0..puzzle.size).cover?(y+yy)
    puzzle[x+xx][y+yy]
  end.compact
end

sel.size.times do |x|
  sel[x].size.times do |y|
    magics.each do |magic|
      next unless sel[x][y] == magic[0]
      poss = words(sel, x, y, magic.size)
      next unless poss.any? {|poss| poss == magic[-1] }
      puts "#{x},#{y} => #{magic}"
    end
  end
end

binding.pry
