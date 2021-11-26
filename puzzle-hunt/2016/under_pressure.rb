require 'letters'
require 'minitest'

require_relative '../annealer'

MAPPING = {
  Y: 1,
  Q: 0,
}

class Equation < Struct.new(*%i[ base a b sum ])
  def valid?
    a.to_i(base) + b.to_i(base) == sum.to_i(base)
  end
end

class Term < Struct.new(*%i[ digits ])
  def to_i(base)
    digits.map {|digit| MAPPING[digit] }.join.to_i(base)
  end
end

EQUATIONS = <<-EQUATIONS.split("\n").map {|line| line.scan(/\w+/).map {|term| term.chars.map(&:to_sym) }}
NNE + JEX = YZQY
SYK + ZFK = YVUY
EYHQ + YYHQ = HHYQ
XVPLM + GCSVY = YZVUMW
HV + HV = NQ
EYHQ + YYHQ = HHEQ
HQKN + DKKV = LLJK
HMLH + FMYZ = YQUTX
CHRBT + VXKWE = YBKAAO
EQUATIONS



final = PuzzleHunt::Annealer.new.simulate(start: start,
                                          neighbor: neighbor,
                                          energy: energy)
puts
puts final

# require 'minitest/autorun'
class TestEquation < Minitest::Test
  def test_equation
    e = Equation.new(2,
                     Term.new(%i[ Y Y Q ]),
                     Term.new(%i[ Y Q Y ]),
                     Term.new(%i[ Y Q Y Y ]))
    assert e.valid?
  end
end
class TestTerm < Minitest::Test
  def test_term
    t = Term.new(%i[ Y Y Q ])
    assert_equal 6, t.to_i(2)
  end
end
