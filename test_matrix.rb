require "./test_helper"
require "matrix"

class TestMatrix < Test::Unit::TestCase
  test "vector" do
    assert { Vector[3, 4].r == 5.0 }
  end
end
