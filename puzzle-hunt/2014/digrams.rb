require 'set'

DIGRAMS = Set.new(<<EOF.scan(/[A-Z]{2}/))
TH  3.15%  TO  1.11%  SA  0.75%  MA  0.56%
HE  2.51   NT  1.10   HI  0.72   TA  0.56
AN  1.72   ED  1.07   LE  0.72   CE  0.55
IN  1.69   IS  1.06   SO  0.71   IC  0.55
ER  1.54   AR  1.01   AS  0.67   LL  0.55
RE  1.48   OU  0.96   NO  0.65   NA  0.54
ES  1.45   TE  0.94   NE  0.64   RO  0.54
ON  1.45   OF  0.94   EC  0.64   OT  0.53
EA  1.31   IT  0.88   IO  0.63   TT  0.53
TI  1.28   HA  0.84   RT  0.63   VE  0.53
AT  1.24   SE  0.84   CO  0.59   NS  0.51
ST  1.21   ET  0.80   BE  0.58   UR  0.49
EN  1.20   AL  0.77   DI  0.57   ME  0.48
ND  1.18   RI  0.77   LI  0.57   WH  0.48
OR  1.13   NG  0.75   RA  0.57   LY  0.47
EOF

FREQS = Hash[<<EOF.split(/\s+/).zip((1..26).to_a.reverse)]
e
t
a
o
i
n
s
h
r
d
l
c
u
m
w
f
g
y
p
b
v
k
j
x
q
z
EOF

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

p FREQS

max = Float::INFINITY
up = %w[ gol caspervan bosombud getme ]#.map(&:reverse)
down = %w[ hawn n s valonyourass ]#.map(&:reverse)
up.permutation.each do |up|
  up = %w[au] + up
  # up = up + %w[ua]
  down.permutation.each do |down|
    # down = down + %w[ ecn ]
    down = down + %w[nce]
    phrase = (up+down).join.split(//)
    # puts phrase.join
    phrase = phrase.values_at(40, 9, 43, 4, 22, 35, 20, 14, 47, 7, 24, 17, 31, 11, 1, 6)
    puts phrase.join
  end
end
# hash = phrase.permutation.each.with_object({}) do |phrase, hash|
#   phrase = phrase.join.each_char.to_a
#   # DIE is 27
#   phrase = phrase.values_at(40, 9, 43, 4, 22, 16, 20, 14, 47, 7, 25, 17, 31, 11, 2, 6)
#   freqs = phrase.each.with_object(Hash.new(0)) do |char, h|
#     h[char] += 1
#   end
#   freqs = freqs.sort_by {|_,v| -v }.join
#   count = levenshtein_distance(freqs, phrase.join)
#   max = count and p max, phrase.join if count <= max
# end
