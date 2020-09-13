require "minitest/autorun"

def floors
  feature_floors = (0..52)  # 52 floors
    .drop(1)                # start on floor 2
    .each_slice(8)          # 8 story period
    .flat_map {|x| x[0,5] } # keep the first 5 floors in the period

  floor_nums = (1..).lazy
    .reject {|x| x == 13 }  # remove the 13th floor number
    .take(53).to_a

  feature_floors.map {|x| floor_nums.fetch(x) }
end

class TestFloors < Minitest::Test
  def test_floors
    assert_equal(
      [
        2, 3, 4, 5, 6,
        10, 11, 12, 14, 15,
        19, 20, 21, 22, 23,
        27, 28, 29, 30, 31,
        35, 36, 37, 38, 39,
        43, 44, 45, 46, 47,
        51, 52, 53, 54
      ],
      floors
    )
  end
end
