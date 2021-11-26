require 'pry'

class Grid < Struct.new(:raw)
  def matches(target)
    each(target.length).select {|word, x, y, dir|
      base = word.chars.map {|c|
        case c.downcase
        when ?*
          '[aeiou]'
        when ' '
          '[^aeiouy]'
        else
          c
        end
      }.join
      r = Regexp.new("^#{base}$", Regexp::IGNORECASE)
      r.match(target)
    }
  end

  def each(len)
    return enum_for(__method__, len) unless block_given?

    raw.each.with_index do |row, y|
      row.size.times do |x|
        yield [row[x,len], x, y, :across] # across
        yield [raw[y,len].map {|row| row[x] }.join, x, y, :down] # down
      end
    end
  end

  def to_s
    raw.join("\n")
  end
  alias_method :inspect, :to_s
end

grid = Grid.new(DATA.readlines.map(&:chomp))
grid.matches(ARGV.shift).each do |w,x,y,dir|
  puts "#{dir}: #{x}, #{y}"
end

__END__
* **OPTEDS***D*
SOMEPLACEHYPOID
NATUREU GAEA AY
C W*YET*RKSHORN
THEE*DECATUR*YA
HYENA SODA **EM
UOD *RTUE*SHIMO
LY**AE*N**NANET
HOCUSPOCUSOTURE
UB*NTU E *WSIYE
YE*TILTS  Y*TAN
ED*WRSVPOLYMPIA
NA E*I*UH*M**NG
TUREEN DEDICATE
AD*TIGERY*R* *R
