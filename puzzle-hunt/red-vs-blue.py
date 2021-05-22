from itertools import *
from z3 import *

row_rules = [
  [17, 4],
  [17, 1, 3],
  [14, 2, 3],
  [12, 1, 3],
  [9, 2, 2, 1],

  [2, 7, 1, 4],
  [4, 4, 3, 1, 1],
  [1, 3, 2, 1, 3, 1, 1],
  [3, 2, 3, 2],
  [3, 1, 2, 3, 1],

  [2, 5, 2, 1, 3, 1],
  [1, 8, 1, 2, 3],
  [1, 11, 1, 1],
  [2, 1, 2, 6, 4, 2],
  [1, 1, 4, 3, 1],

  [2, 2, 1, 3, 2],
  [1, 2, 3, 1],
  [1, 2, 1, 3],
  [4, 2, 1],
  [3, 1, 2],

  [3, 2, 1],
  [3, 1, 1, 2],
  [3, 2, 1],
  [3, 2, 2],
  [3, 2, 1],

  [4, 3, 2],
  [2, 3, 3, 1],
  [3, 4, 4],
  [6, 1, 1],
  [4],
]

col_rules = [
  [3, 2, 2, 1, 1, 11],
  [3, 3, 2, 1, 2, 11],
  [3, 4, 2, 3, 6, 2],
  [3, 4, 3, 6, 1],
  [3, 7, 1, 6],

  [3, 4, 4, 7],
  [3, 2, 6, 6],
  [3, 8, 3, 1],
  [3, 8, 2, 1],
  [3, 8, 2, 2],

  [3, 6, 1, 1],
  [3, 3, 2, 6],
  [3, 1, 4, 5],
  [3, 4, 2, 5],
  [6, 7, 1, 4],

  [6, 9, 2, 4],
  [6, 1, 9, 1, 3],
  [6, 4, 9, 2, 3],
  [4, 6, 9, 1, 2],
  [2, 1, 3, 9, 2, 2],

  [4, 1, 2, 11, 1],
  [6, 5, 9, 2],
  [7, 6, 6, 4],
  [6, 6, 4, 6],
  [1, 7, 6, 1, 8],

  [1, 1, 3, 6, 10],
  [2, 1, 1, 4, 12],
  [2, 1, 2, 1, 1, 14],
  [3, 1, 3, 16],
  [3, 4, 18],
]

def pairwise(iterable):
    "s -> (s0,s1), (s1,s2), (s2, s3), ..."
    a, b = tee(iterable)
    next(b, None)
    return zip(a, b)

def cell(x, y):
  return Bool(f"cell-{x},{y}")

def row(y):
  return [cell(x, y) for x in range(0, len(col_rules))]

def col(x):
  return [cell(x, y) for y in range(0, len(row_rules))]

def create_constraints(stripe_name, stripe_constraints, stripe, f):
  group_count = len(stripe_constraints)
  group_start = [Int(f"{stripe_name}-{i}-start") for i in range(0, group_count)]
  group_end = [Int(f"{stripe_name}-{i}-end") for i in range(0, group_count)]

  # # Start and end of each group
  for i in range(0, group_count):
    s.add(group_start[i] >= 0, group_start[i] < len(stripe))
    s.add(group_end[i] >= 0, group_end[i] < len(stripe))
    s.add(group_end[i] - group_start[i] == stripe_constraints[i] - 1)

  # Gap between each group and following group
  for i, j in pairwise(range(0, group_count)):
    s.add(group_start[j] >= group_end[i] + 2)

  # Cells
  for k in range(0, len(stripe)):
    cell_in_specific_group = [
        And(k >= group_start[i], k <= group_end[i])
        for i in range(0, group_count)
    ]
    s.add(f(stripe[k], Or(*cell_in_specific_group)))

s = Solver()

for x, col_rule in enumerate(col_rules):
  create_constraints(f"col-{x}", col_rule, col(x), lambda a,b: a == b)

for y, row_rule in enumerate(row_rules):
  create_constraints(f"row-{y}", row_rule, row(y), lambda a,b: a != b)

s.check()
m = s.model()

for y in range(0, len(row_rules)):
  row = "".join(["█" if m[cell(x,y)] else " " for x in range(0, len(col_rules))])
  print(row)

