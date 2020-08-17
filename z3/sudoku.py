from z3 import *

# 9x9 matrix of integer variables
X = [ [ Int("x_%s_%s" % (i+1, j+1)) for j in range(9) ]
      for i in range(9) ]

# each cell contains a value in {1, ..., 9}
cells_c  = [ And(1 <= X[i][j], X[i][j] <= 9)
             for i in range(9) for j in range(9) ]

# each row contains a digit at most once
rows_c   = [ Distinct(X[i]) for i in range(9) ]

# each column contains a digit at most once
cols_c   = [ Distinct([ X[i][j] for i in range(9) ])
             for j in range(9) ]

# each 3x3 square contains a digit at most once
sq_c     = [ Distinct([ X[3*i0 + i][3*j0 + j]
                        for i in range(3) for j in range(3) ])
             for i0 in range(3) for j0 in range(3) ]

sudoku_c = cells_c + rows_c + cols_c + sq_c

# # sudoku instance, we use '0' for empty cells
# instance = ((0,0,0,0,0,0,0,0,0),
#             (0,0,0,0,0,0,0,0,0),
#             (0,0,0,0,0,0,0,0,0),
#             (0,0,0,0,0,0,0,0,0),
#             (0,0,0,0,0,0,0,0,0),
#             (0,0,0,0,0,0,0,0,0),
#             (0,0,0,0,0,0,0,0,0),
#             (0,0,0,0,0,0,0,0,0),
#             (0,0,0,0,0,0,0,0,0))

# instance_c = [ If(instance[i][j] == 0,
#                   True,
#                   X[i][j] == instance[i][j])
#                for i in range(9) for j in range(9) ]

evens_c = [
        X[0][3] % 2 == 0,
        X[0][7] % 2 == 0,
        X[2][1] % 2 == 0,
        X[2][5] % 2 == 0,
        X[4][3] % 2 == 0,
        X[4][7] % 2 == 0,
        X[6][1] % 2 == 0,
        X[6][5] % 2 == 0,
        X[8][3] % 2 == 0,
        ]

odds_c = [
        X[1][2] % 2 == 1,
        X[1][6] % 2 == 1,
        X[3][0] % 2 == 1,
        X[3][4] % 2 == 1,
        X[3][8] % 2 == 1,
        X[5][2] % 2 == 1,
        X[5][6] % 2 == 1,
        X[7][0] % 2 == 1,
        X[7][4] % 2 == 1,
        ]

sums_c =[
        X[0][5] + X[1][4] + X[2][3] + X[3][2] + X[4][1] + X[5][0]                     == 45,
        X[1][0] + X[2][1] + X[3][2] + X[4][3] + X[5][4] + X[6][5] + X[7][6] + X[8][7] == 56,
        X[3][0] + X[4][1] + X[5][2] + X[6][3] + X[7][4] + X[8][5]                     == 18,
        X[0][6] + X[1][7] + X[2][8]                                                   == 11,
        X[0][3] + X[1][4] + X[2][5] + X[3][5] + X[4][7] + X[5][8]                     == 24,
        X[2][8] + X[3][7] + X[4][6] + X[5][5] + X[6][4] + X[7][3] + X[8][2]           == 25,
        X[6][8] + X[7][7] + X[8][6]                                                   == 8,
        ]

s = Solver()
# s.add(sudoku_c + instance_c)
# s.add(sudoku_c + evens_c + odds_c + sums_c)
s.add(sudoku_c + evens_c + odds_c)
if s.check() == sat:
    m = s.model()
    r = [ [ m.evaluate(X[i][j]) for j in range(9) ]
          for i in range(9) ]
    print_matrix(r)
else:
    print("failed to solve")
