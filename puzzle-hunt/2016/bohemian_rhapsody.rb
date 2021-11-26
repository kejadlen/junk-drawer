require_relative '../annealer'

Card = Struct.new(*%i[ name type validation ]) do
  def inspect
    "<#{name} - #{type}>"
  end
end

instructions = [
  [
    Card.new(:a, :unfold, ->(c, i) {
      i <= 9 && 
        c[i+1].first.type != :cut && c[0].first.type != :cut
    }),
    Card.new(:e, :unfold, ->(c, _) {
      c[0..1].count {|x| x.first.type == :cut } == 0 &&
        c[2].first.type == :cut
    }),
  ],
  [
    Card.new(:t, :fold_out, ->(c, i) {
      i <= 9 && c[i+1].first.type == :cut }
    ),
    Card.new(:k, :unfold, ->(c, i) { i != 0 && c[i-1].first.type == :cut }),
  ],
  [
    Card.new(:z, :cut, ->(c, _) { c.count {|x| x.first.type == :fold_out } == 2}),
    Card.new(:w, :fold_out, ->(c, i) {
      i > 2 &&
        c[i-3..i].map(&:first).map(&:type).uniq.count == 4
    }),
    Card.new(:p, :fold_in, ->(c, i) { i == 7 }),
    Card.new(:c, :fold_out, ->(_, i) { i == 1 }),
  ],
  [
    Card.new(:x, :unfold, ->(c, _) {
      c[5].first.type == :fold_in && c[6].first.type == :fold_in
    }),
    Card.new(:d, :cut, ->(c, _) {
      c.values_at(3, 7, 8).map(&:first).map(&:type).uniq.count == 1
    }),
  ],
  [
    Card.new(:f, :cut, ->(c, i) { c[0...i].none? {|x| x.first.type == :cut }}),
    Card.new(:y, :cut, ->(c, _) { c[8].first.type == :cut }),
  ],
  [
    Card.new(:q, :fold_out, ->(c, i) {
      i != 0 &&
        c[i-1].first.type == :cut &&
        c[5].first.type == :cut
    }),
  ],
  [
    Card.new(:l, :fold_in, ->(_, i) { i == 6 || i == 8 }),
    Card.new(:j, :cut, ->(_, i) { i == 2 || i == 3 }),
  ],
  [
    Card.new(:i, :fold_in, ->(c, i) {
      i != 0 &&
        c[i-1].first.type == :fold_out &&
        c[0...i-1].any? {|x| x.first.type == :fold_out }
    }),
    Card.new(:n, :fold_in, ->(c, i) {
      c.count {|x| x.first.type == :fold_out } == 4 &&
        c[0...i].any? {|x| x.first.type == :fold_out }
    }),
    Card.new(:v, :fold_out, ->(c, i) {
      i != 0 &&
        c[i].first.type == c[i-1].first.type
    }),
  ],
  [
    Card.new(:s, :fold_in, ->(c, _) { c.count {|x| x.first.type == :unfold } == 5 }),
    Card.new(:o, :fold_in, ->(c, i) {
      c[0...i].map(&:first).map(&:type).uniq.count == 3 &&
        c[i+1..-1].map(&:first).map(&:type).uniq.count == 3
    }),
  ],
  [
    Card.new(:r, :fold_in, ->(_, i) { ![0, 3, 5, 9].include?(i) }),
    Card.new(:u, :cut, ->(_, i) { ![1, 4, 8].include?(i) }),
  ],
  # [
  #   Card.new(:m, :cut, ->(_, i) { i == 10 }),
  # ],
]


energy = ->(instructions) {
  instructions = instructions + [ Card.new(:m, :cut, ->(_, i) { i == 10 }) ]
  instructions.select.with_index {|c, i|
    c.first.validation.call(instructions, i)
  }.count
}

max_energy = 0

instructions.permutation.each do |i|
end

# neighbor = ->(instructions) {
#   i, j = (0..10).to_a.sample(2)
#   case rand(2)
#   when 0
#     instructions[i], instructions[j] = instructions[j], instructions[i]
#   when 1
#     instructions[i].shuffle!
#   end
#   instructions
# }

# energy = ->(instructions) {
#   1 / instructions.select.with_index {|c, i|
#     c.first.validation.call(instructions, i)
#   }.count.to_f
# }

# a = PuzzleHunt::Annealer.new
# a.simulate(start: instructions, neighbor: neighbor, energy: energy)
