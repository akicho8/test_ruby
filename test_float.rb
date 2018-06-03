require "./test_helper"

class TestFloat < Test::Unit::TestCase
  test "ceil" do                        # 上に近い整数
    assert_equal(+2,    1.5.ceil)
    assert_equal(-1, (-1.5).ceil)
  end

  test "floor" do               # 下に近い整数
    assert_equal(+1,    1.5.floor)
    assert_equal(-2, (-1.5).floor)
  end

  test "round" do               # 上下に近い整数
    assert_equal(+2, +1.5.round)
    assert_equal(-2, -1.5.round)
  end

  test "to_i" do
    assert_equal(+1, +1.5.to_i) # 0に近い整数
    assert_equal(-1, -1.5.to_i)
  end

  test "infinite?" do
    assert_equal(nil, (0.0).infinite?) # 有限
    assert_equal(nil, (2.3).infinite?) # 有限
    assert_equal(-1, ((-1.0/0).infinite?)) # -の無限
    assert_equal(+1, ((+1.0/0).infinite?)) # +の無限
  end

  test "to_s" do
    assert_equal("1.23", 1.23.to_s)
    assert_equal("-Infinity", ((-1.0/0).to_s)) # -の無限(文字列)
    assert_equal("Infinity", ((+1.0/0).to_s)) # +の無限(文字列)
  end

  test "nan?" do                        # 無効なIEEE?
    x = -1.0
    assert_equal(false, x.nan?)
    assert_equal(true, x.finite?)
    assert_raise(Math::DomainError){Math.log(x)} # 昔は Errno::EDOM だった
  end
end
