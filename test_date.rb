require "./test_helper"
require "date"

class TestDate < Test::Unit::TestCase
  # 便利な定数
  test "constants" do
    assert_equal([nil, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], Date::MONTHNAMES)
    assert_equal(["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], Date::DAYNAMES)
    assert_equal([nil, "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], Date::ABBR_MONTHNAMES)
    assert_equal(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], Date::ABBR_DAYNAMES)
  end

  test "new" do
    assert_equal("2000-01-03", Date.new(2000, 1, 3).to_s)
    assert_equal("2000-01-03", Date.civil(2000, 1, 3).to_s) # civilはnewと同じ意味
    assert_equal("2000-01-03", Date.new(2000, 1, 3).strftime("%Y-%m-%d")) # to_sを使うのと同じ
    assert_equal("2000-01-31", Date.new(2000, 1, -1).to_s) # 月末の求め方
  end

  # 文字列を解析してオブジェクトを返す
  test "parse" do
    assert_equal("2000-01-03", Date.parse("2000/1/3").to_s)
  end

  # ハッシュで返す
  test "_parse" do
    assert_equal({:mon=>1, :year=>2000, :mday=>3}, Date._parse("2000/1/3"))
  end

  # 今日の日付を返す Time.now.strftime を使うより簡潔
  test "today" do
    assert Date.today
  end

  test "valid_date?" do
    assert_equal(true, Date.valid_date?(2000, 1, 3))
    assert_equal(false, Date.valid_date?(2000, 1, 32))
  end

  test "月初めから減算するとどうなる？" do
    assert_equal("1999-12-31", (Date.new(2000, 1, 1) - 1).to_s)
  end
end
# >> Loaded suite -
# >> Started
# >> .......
# >> Finished in 0.002191 seconds.
# >> -------------------------------------------------------------------------------
# >> 7 tests, 14 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 3194.89 tests/s, 6389.78 assertions/s
