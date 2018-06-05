


require "./test_helper"

class TestTime < Test::Unit::TestCase
  test "s_at" do
    assert_equal(0, Time.at(0)) if RUBY_VERSION <= "1.6"
    assert_kind_of(Time, Time.at(0)) if RUBY_VERSION >= "1.8"
    assert_equal("Thu Jan 01 09:00:00 JST 1970", Time.at(0).to_s)
  end
  test "s_gm" do                 # utc
    assert_equal("Fri Jan 03 03:00:00 UTC 2000", Time.gm(2000,"jan",3,3,0,0).to_s)
  end
  test "s_local" do              # mktime
    assert_equal("Fri Jan 03 03:00:00 JST 2000", Time.local(2000,"jan",3,3,0,0).to_s)
  end
  test "s_new" do                # now
    Time.now
    Time.new
  end
  test "s_times" do
    assert_equal(["utime", "stime", "cutime", "cstime"], Time.times.members) if RUBY_VERSION <= "1.6"
    assert_equal(["utime", "stime", "cutime", "cstime"], Process.times.members) if RUBY_VERSION >= "1.8"
  end
  test "PLUS_MINUS" do
    assert_equal("Thu Jan 01 09:00:00 JST 1970", (Time.at(1)-1).to_s)
    assert_equal("Thu Jan 01 09:00:02 JST 1970", (Time.at(1)+1).to_s)
  end
  test "COMPARE" do
    assert_equal(0,  Time.at(0) <=> Time.at(0))
    assert_equal(-1, Time.at(0) <=> Time.at(1))
    assert_equal(+1, Time.at(1) <=> Time.at(0))
  end
  test "asctime" do              # ctime
    assert_equal("Thu Jan  1 09:00:00 1970", Time.at(0).asctime)
  end
  test "day" do
    assert_equal(1970, Time.at(0).year)  # 年
    assert_equal(1,    Time.at(0).mon)   # 月
    assert_equal(1,    Time.at(0).month) # 月
    assert_equal(1,    Time.at(0).day)   # 日
    assert_equal(1,    Time.at(0).mday)  # 日
    assert_equal(1,    Time.at(0).yday)  # 日(1-366)
    assert_equal(4,    Time.at(0).wday)  # 曜日
    assert_equal(9,    Time.at(0).hour)  # 時
    assert_equal(0,    Time.at(0).min)   # 分
    assert_equal(0,    Time.at(0).sec)   # 秒
    assert_equal(0,    Time.at(0).usec)  # マイクロ秒
    assert_equal(0,    Time.at(0).tv_usec)  # マイクロ秒
    assert_equal("JST",Time.at(0).zone)  # タイムゾーン
  end
  test "gmt?" do
    assert_equal(true,  Time.gm(2000,"jan",3,3,0,0).gmt?)
    assert_equal(false, Time.local(2000,"jan",3,3,0,0).gmt?)
    assert_equal(false, Time.now.gmt?)
  end
  test "gmtime" do               # gmtime=utc / gmt?=utc?
    x = Time.now
    x.gmtime
    assert_equal(true,  x.gmt?)

    x = Time.now
    x.utc
    assert_equal(true,  x.utc?)
  end
  test "isdst" do                # 夏か? (なぜか全部夏じゃないとなるのはなぜ?)
    assert_equal("000000000000", (1..12).collect{|i| Time.local(2000, i, 1).isdst ? "1":"0"}.join)
  end
  test "localtime" do
    x = Time.now
    x.gmtime
    assert_equal(true,  x.gmt?)
    x.localtime
    assert_equal(false,  x.gmt?)
  end
  test "strftime" do
    assert_equal("09:00:00", Time.at(0).strftime("%H:%M:%S"))
  end
  test "to_a" do
    assert_equal([0, 0, 9, 1, 1, 1970, 4, 1, false, "JST"], Time.at(0).to_a)
  end
  test "to_f" do
    assert_equal(1234.5678, Time.at(1234.5678).to_f)
  end
  test "to_i" do
    assert_equal(1234, Time.at(1234.5678).to_i)
    assert_equal(1234, Time.at(1234.5678).tv_sec)
  end
  test "to_s" do
    assert_equal("Thu Jan 01 09:00:00 JST 1970", Time.at(0).to_s)
    assert_equal("Fri Jan 03 03:00:00 UTC 2000", Time.gm(2000,"jan",3,3,0,0).to_s)
    assert_equal("Fri Jan 03 03:00:00 JST 2000", Time.local(2000,"jan",3,3,0,0).to_s)
  end
  test "between?" do
    assert_equal(true, Time.at(1).between?(Time.at(1), Time.at(3)))
    assert_equal(true, Time.at(2).between?(Time.at(1), Time.at(3)))
    assert_equal(true, Time.at(3).between?(Time.at(1), Time.at(3)))
    assert_equal(false, Time.at(4).between?(Time.at(1), Time.at(3)))
  end
end
