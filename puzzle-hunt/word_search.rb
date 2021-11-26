require 'minitest/autorun'

module PuzzleHunt
  class WordSearch
    # Breaks a block of text into a matrix of single characters.
    def self.from_chars(input)
      data = input.chomp.split("\n").map {|row| row.split(//) }
      self.new(data)
    end

    include Enumerable

    DIRS = [-1, 0, 1].flat_map {|x| [-1, 0, 1].map {|y| [x,y] }} - [[0,0]]

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def [](x, y)
      data[x][y]
    end

    def each_word
      return enum_for(__method__) unless block_given?

      data.each.with_index do |row, i|
        row.each.with_index do |elem, j|
          yield elem

          DIRS.map do |dx, dy|
            x,y = i,j
            word = [ elem ]

            loop do
              x += dx
              y += dy
              break unless (0...data.size).cover?(x) && (0...row.size).cover?(y)
              word << self[x,y]
              yield word.join
            end
          end
        end
      end
    end
  end

  class TestWordSearch < Minitest::Test
    def test_from_chars
      ws = WordSearch.from_chars("ab\ncd")
      assert_equal 'a', ws[0,0]
      assert_equal 'b', ws[0,1]
      assert_equal 'c', ws[1,0]
      assert_equal 'd', ws[1,1]
    end

    def test_each
      ws = WordSearch.from_chars("abc\ndef\nghi")
      words = ws.each_word.map.to_a
      %w[ a b c d e f g h i
          ab ad ae
          ea eb ec ed ef eg eh ei
          abc def ghi aei adg cfi ].each do |word|
        assert_includes words, word
      end
    end
  end
end
