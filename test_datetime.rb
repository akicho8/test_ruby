require "test/unit"
require "date"

class TestDateTime < Test::Unit::TestCase
  test "ancestors" do
    assert_kind_of(Array, DateTime.ancestors)
    assert_equal("[DateTime, Date, Comparable, Object, Kernel, BasicObject]", DateTime.ancestors.inspect)
  end

  test "parse" do
    assert_equal("2000-01-03T12:34:56+00:00", DateTime.parse("2000-01-03 12:34:56").to_s)
  end

  # 相互変換
  # もちろん Date から DateTime への変換も可能。
  test "class_convert" do
    date_time_obj = DateTime.parse("2000-01-03 12:34:56")
    assert_equal(DateTime, date_time_obj.class)
    assert_equal(Time, date_time_obj.to_time.class)         # DateTime => Time
    assert_equal(Date, date_time_obj.to_date.class)         # DateTime => Date
    assert_equal(DateTime, date_time_obj.to_datetime.class) # DateTime => DateTime
    assert_equal("2000-01-03", date_time_obj.to_date.to_s)
  end
end
