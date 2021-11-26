words = File.read("/usr/share/dict/words")
  .downcase
  .split("\n")

# haystack = words.select {|w| w =~ /^...ve$/ }
# p haystack.select {|x|
#   words.include?("#{x[0]}o#{x[1]}#{x[2]}t")
# }

puts words
  .select {|x| x.size == 6 }
  .select {|x| x =~ /hy|h....y/ }
