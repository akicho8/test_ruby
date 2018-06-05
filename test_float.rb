require "./test_helper"

class TestFloat < Test::Unit::TestCase
  # 上に近い
  test "ceil" do
    assert { 1.5.ceil == 2 }
    assert { -1.5.ceil == -1 }
  end

  # 下に近い
  test "floor" do
    assert { 1.5.floor == 1 }
    assert { -1.5.floor == -2 }
  end

  # 上下に近い
  test "round" do
    assert { 1.5.round == 2 }
    assert { -1.5.round == -2 }
  end

  # 0に近い
  test "to_i" do
    assert { 1.5.to_i == 1 }
    assert { -1.5.to_i == -1 }
  end

  test "infinite?" do
    assert { (0.0).infinite? == nil }
    assert { (2.3).infinite? == nil }
    assert { (-1.0 / 0).infinite? == -1 }
    assert { (+1.0 / 0).infinite? == 1 }
  end

  test "to_s" do
    assert { 1.23.to_s == "1.23" }
    assert { (-1.0 / 0).to_s == "-Infinity" }
    assert { (1.0 / 0).to_s == "Infinity" }
  end

  # 無効なIEEE?
  test "nan?" do
    x = -1.0
    assert { x.nan? == false }
    assert { x.finite? == true }
    assert_raise(Math::DomainError) { Math.log(x) } # 昔は Errno::EDOM だった
  end
end
# >> Loaded suite -
# >> Started
# >> .......
# >> Finished in 0.006038 seconds.
# >> -------------------------------------------------------------------------------
# >> 7 tests, 18 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 1159.32 tests/s, 2981.12 assertions/s
