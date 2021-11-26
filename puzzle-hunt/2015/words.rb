#!/usr/bin/env ruby

words = File.read('/usr/share/dict/words')

dict = {}
Dir['final/*'].each do |file|
  words = File.read(file)
  words.encode!('UTF-16', 'UTF-8', invalid: :replace)
  words.encode!('UTF-8', 'UTF-16', invalid: :replace)
  words = words.split("\n")
  words.select! {|word| word.size == 15 }
  words.each do |word|
    dict[word.downcase.split(//).sort.join] = word
  end
end

word = 'TINULMFCURTILANO'
word = 'SCNCEAOULBENAORT'
word = 'ITITENAORRTNPESR'
word = 'VEISINNQETUSSSII'
word = 'CLAUOITGNPZNECWI'
word = 'OKLENWCBFLAAEDGE'
word = 'NOLIIAGZTSSEAEND'
word = 'ITITENAORRTNPESR'
word = 'ERIETARZCSCALMIH'
word = 'IDETHMINSGISUINT'
word = 'TSDSNPIAETIPMNOP'

word = 'GRLITOSARNEPRWFS'
word = 'DNICIANOCRTEATES'

word.size.times do |i|
  w = word[0, i] + word[i+1..-1]
  w = w.downcase.split(//).sort.join
  w = dict[w]
  if w
    puts w
    puts word[i]
  end
end
