require 'open-uri'

# require 'nokogiri'
require 'pry'

PYRAMID = <<EOF.split("\n")
teal
echoi
beaker
honkers

cardinals
gulfstream
rubberducky
EOF

MUPPETS = File.read(File.expand_path('../muppets.txt', __FILE__)).split("\n").compact
MUPPETS.each(&:downcase!)
MUPPETS.each {|m| m.gsub!(/[^a-z]/i, '') }

def levenshtein_distance(s, t)
  m = s.length
  n = t.length
  return m if n == 0
  return n if m == 0
  d = Array.new(m+1) {Array.new(n+1)}

  (0..m).each {|i| d[i][0] = i}
  (0..n).each {|j| d[0][j] = j}
  (1..n).each do |j|
    (1..m).each do |i|
      d[i][j] = if s[i-1] == t[j-1]  # adjust index into string
                  d[i-1][j-1]       # no operation required
                else
                  [ d[i-1][j]+1,    # deletion
                    d[i][j-1]+1,    # insertion
                    d[i-1][j-1]+1,  # substitution
                  ].min
                end
    end
  end
  d[m][n]
end

# doc = Nokogiri::HTML(open('http://en.wikipedia.org/wiki/List_of_Muppets').read)

min = Float::INFINITY
while true
  letters = PYRAMID.zip(PYRAMID.map {|i| rand(i.size) }).map {|row,i| row[i] }
  word = letters.join
  muppet = MUPPETS.sort_by {|m| levenshtein_distance(m, word) }[0]
  dist = levenshtein_distance(muppet, word)
  puts "#{word} (#{dist}): #{muppet}" or min = dist if dist <= min
end

binding.pry
