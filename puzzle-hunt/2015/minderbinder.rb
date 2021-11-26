#!/usr/bin/env ruby

require 'set'

require 'pry'

DICT = Set.new(File.read('/usr/share/dict/words').split("\n").map(&:downcase))

milo = <<MILO.chomp.split("\n").map {|i| i.split(//) }
LAUGEIYCYCOOBTYRXQFI
AYWYDETQHPEMLGBSHFUR
SROEFMUMRKHRJMBYZVPV
TANGGSENMEIIHJFNNLVI
MISTHSOUDNASHTIWLETU
FNDWRSMEAOLLAIPWBJPP
UKEESSLOWOOALNIUYECN
YZRACFROOSCMATEWBERT
DXUCOATRTNILSAIWNVHC
BKVHONRGTNRELEHLQWMK
YNSBITSOCKIACSALTDDW
HIKITCNAWONKSIRMILSO
WTNLVKTTUDFSCRRXLOSO
ECALRUDSLOOFPOWASHTX
HHBANDHFIORTAQLQSNVV
OSBBASELIFARMUZWUFZF
BEAKETIMELINEIQUVJEF
OTSMBAOLKELPRPTKKJCA
SCSIFXRUTNKAEMCCGBWH
GHMSEUUCQKERHVLRPVKI
MILO

def milo.words(x, y, n=3)
  dirs = (1..n).map do |i|
    [[0,i], [0,-i], [i,0], [-i,0],
     [i,i], [i,-i], [-i,i], [-i,-i]]
  end
  dirs = (0..7).map {|i| [[0,0]].concat(dirs.map {|x| x[i] }) }

  words = dirs.map do |dir|
    word = dir.map do |xx,yy|
      next unless (0..19).cover?(x+xx) && (0..19).cover?(y+yy)
      self[x+xx][y+yy]
    end.join
  end.select {|word| (word.size == n+1) && DICT.include?(word.downcase) }
end

all = []
milo.size.times do |x|
  milo[x].size.times do |y|
    words = milo.words(x,y,3)
    next if words.empty?
    puts "(#{x},#{y}): #{words.join(', ')}"
    all.concat(words)
  end
end

def all.ring(word)
  word.size.times.flat_map do |i|
    r = word.dup
    r[i] = '.'
    self.grep(Regexp.new(r)).reject {|w| w == word }
    # puts poss unless poss.empty?
  end
end

all.map!(&:downcase)

binding.pry
