points = [[1.61803398875, 1.38541802],
          [3.1415926535, Complex(0,1)],
          [2.718281828459, Complex(-3.580050311,4.624555558)],
          [Complex(0,1), 30]]

points.map {|x_i,y_i| y_i * points.reject {|x_j,_| x_i == x_j }.map {|x_j,_| x_j / (x_j - x_i) }.inject(:*)}.inject(:+)

d = Complex(0.19050299184179664,0.18052001388206307)

gamma = 0.577215664901532860
x_points = points.map(&:first) << gamma

p points.map {|x_i,y_i| y_i * x_points.reject {|x_j,_| x_i == x_j }.map {|x_j,_| x_j / (x_j - x_i) }.inject(:*)}.inject(:+)

foo = d - Complex(-5.64103099802664,15.438114250246791)

p foo - x_points.reject {|x_j,_| gamma == x_j }.map {|x_j,_| x_j / (x_j - gamma) }.inject(:*)

