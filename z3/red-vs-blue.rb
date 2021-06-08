require "z3"

class NonogramSolver
  def initialize
    @row_constraints = [
      [3],
      [5],
      [3,1],
      [2,1],
      [3,3,4],
      [2,2,7],
      [6,1,1],
      [4,2,2],
      [1,1],
      [3,1],
      [6],
      [2,7],
      [6,3,1],
      [1,2,2,1,1],
      [4,1,1,3],
      [4,2,2],
      [3,3,1],
      [3,3],
      [3],
      [2,1],
    ]
    @column_constraints = [
      [2],
      [1,2],
      [2,3],
      [2,3],
      [3,1,1],
      [2,1,1],
      [1,1,1,2,2],
      [1,1,3,1,3],
      [2,6,4],
      [3,3,9,1],
      [5,3,2],
      [3,1,2,2],
      [2,1,7],
      [3,3,2],
      [2,4],
      [2,1,2],
      [2,2,1],
      [2,2],
      [1],
      [1],
    ]
    @row_count = @row_constraints.size
    @column_count = @column_constraints.size
    @solver = Z3::Solver.new
  end

  def cell(x,y)
    Z3.Bool("cell#{x},#{y}")
  end

  def row(y)
    (0...@column_count).map{|x| cell(x,y) }
  end

  def column(x)
    (0...@row_count).map{|y| cell(x,y) }
  end

  def setup_grid_constraints!
    (0...@column_count).each do |x|
      setup_stripe_constraints! "column-#{x}", @column_constraints[x], column(x)
    end

    (0...@row_count).each do |y|
      setup_stripe_constraints! "row-#{y}", @row_constraints[y], row(y)
    end
  end

  def setup_stripe_constraints!(stripe_name, stripe_constraints, stripe)
    group_count = stripe_constraints.size
    group_start = (0...group_count).map{|i| Z3.Int("#{stripe_name}-#{i}-start")}
    group_end = (0...group_count).map{|i| Z3.Int("#{stripe_name}-#{i}-end")}

    # Start and end of each group
    (0...group_count).each do |i|
      @solver.assert (group_start[i] >= 0) & (group_start[i] < stripe.size)
      @solver.assert (group_end[i] >= 0) & (group_end[i] < stripe.size)
      @solver.assert group_end[i] - group_start[i] == stripe_constraints[i] - 1
    end
    # Gap between each group and following group
    (0...group_count).each_cons(2) do |i,j|
      @solver.assert group_start[j] >= group_end[i] + 2
    end
    # Cells
    (0...stripe.size).each do |k|
      cell_in_specific_group = (0...group_count).map{|i|
        (k >= group_start[i]) & (k <= group_end[i])
      }
      @solver.assert stripe[k] == Z3.Or(*cell_in_specific_group)
    end
  end

  def solve!
    setup_grid_constraints!
    if @solver.satisfiable?
      model = @solver.model
      (0...@row_count).each do |y|
        (0...@column_count).each do |x|
          value = model[cell(x,y)].to_s
          print value == "true" ? "\u25FC" : "\u25FB"
        end
        print "\n"
      end
    else
      puts "Nonogram has no solution"
    end
  end
end

if __FILE__ == $0
  nonogram = NonogramSolver.new
  nonogram.solve!
end
