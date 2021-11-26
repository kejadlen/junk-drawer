dict = File.read('/usr/share/dict/words')
           .split("\n")
           .select {|w| w.length == 8 }
           .each.with_object({}) {|w,h|
             k = w.downcase.chars.sort.join
             h[k] = w.downcase
           }

words = %w[
  pigment icon
  arose talc
  platonic asteroid
  asimov vulcan
]

8.times do
  words << ' '
end

circle_indices = %w[ 4 9 10 13 19 23 27 31 34 38 41 43 49 51 55 ].map(&:to_i)
yellow_indices = %w[ 1 7 18 22 28 35 40 48 ].map(&:to_i)

found = Set.new

# words.permutation do |perm|
#   chars = perm.join(' ').chars << ' '
loop do
  perm = words.shuffle
  chars = perm.join.chars

  # perm = 'platonic vulcan asimovarose  icon asteroidpigment  talc '
  # chars = perm.chars

  chars.length.times do
    yellow = chars.values_at(*yellow_indices).sort.join
    circles = chars.values_at(*circle_indices)

    if !circles.include?(' ') && dict.has_key?(yellow) && !found.include?(yellow)
      found << yellow

    # if dict.has_key?(yellow)
      puts <<-PUTS
yellow: #{dict[yellow]}
circles: #{circles.join}

      PUTS

      exit if dict[yellow] == 'virtuoso'
    end

    chars.rotate!
  end
end
