module PuzzleHunt
  class Annealer
    def acceptance_probability(e, e_, t)
      (e_ < e) ? 1 : Math.exp((e-e_)/t.to_f)
    end

    def simulate(start:, neighbor:, energy:)
      state = start
      t = 10000
      k = 0

      while true do
        e = energy.call(state)

        return state if e == 0

        if k % 1000 == 0
          puts "Step: #{k}, Temp: #{t}, Energy: #{e}"
          p state
        end

        state_ = neighbor.call(state)
        e_ = energy.call(state_)
        p = acceptance_probability(e, e_, t)
        state = state_ if p > rand

        # return state if t <= 1

        t *= 0.998
        k += 1
      end
    end
  end
end

if __FILE__ == $0
  start = (1..81).to_a.shuffle.map {|i| i % 9 }.each_slice(9).to_a

  neighbor = ->(state) do
    x1,y1 = (0..8).to_a.sample(2)
    x2,y2 = (0..8).to_a.sample(2)
    neighbor = state.map(&:dup)
    neighbor[x1][y1], neighbor[x2][y2] = state[x2][y2], state[x1][y1]
    neighbor
  end

  energy = ->(state) do
    ideal = (0..8).to_a
    energy = 0

    (0..8).each do |i|
      energy += 9 - state[i].uniq.size
      energy += 9 - state.map {|row| row[i] }.uniq.size
    end

    dxy = (0..2).flat_map {|i| (0..2).map {|j| [i,j] } }
    (0..2).each do |i|
      (0..2).each do |j|
        sub_grid = dxy.map do |dx,dy|
          state[3*i+dx][3*j+dy]
        end
        energy += 9 - sub_grid.uniq.size
      end
    end

    energy
  end

  final = PuzzleHunt::Annealer.new.simulate(start: start,
                                            neighbor: neighbor,
                                            energy: energy)
  puts
  final.each {|row| p row }
end
