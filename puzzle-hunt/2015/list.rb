#!/usr/bin/env ruby

latin = Hash[File.read('latin.2.txt').downcase.gsub(/\s*:.*$/, '').split("\n").map {|line| [line.split(//).sort.join, line] }]

list = DATA.read.chomp.split("\n")

list.each do |word|
  # subj = word
  # test = latin[subj]
  # puts "#{word} => #{test}" if test
  word.size.times do |i|
    subj = word[0,i] + word[i+1..-1]
    test = latin[subj]
    puts "#{word} => #{test}" if test
  end
end

__END__
aaeirs
aaaqu
bgiins
aelrrt
aegmnrstu
aceimnrsuu
aamruu
abceor
adghmnrrruyy
blmmpruu
amnnsstu
flrsuuu
emnouv
aacginnoosttuu
beempst
adegiinrsttx
cdeeimnntuu
egiiiinrsttv
aacdehrst
aceillmruu
aaclmrstuu
cdiimmoorrtu
ceeefimorrtu
ciiimoprrstu
acimns
acorsst
acssttu
eqsuuu
alpsuu
aacmsu
cciipss
erssuu
adeiilnns
acceeeilsssst
deosuux
eeginssy
aejlo
cdhijtu
egimnru
aillmps
aiimnnnopsstuu
agssstuuu
cdmmoosuu
acinnossttuu
acdeeiilnot
adgiimnot
aabgil
aadhinnr
aiiiimmnrsux
aajnrtu
aaeeinpssv
eiillnstuv
aiorsu
acprtu
dgiisstu
abilmsu
amnsuu
bcepstu
dellopx
celosuu
egmrrtu
bciilmrsuu
eenrtuv
adeirs
aaiiqrsuu
acciinoprr
egiiimn
abiilr
aagiirrssttu
cioprsssu
arstuuv
