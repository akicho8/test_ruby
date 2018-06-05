


require "./test_helper"

require "parsedate"

class TestParseDate < Test::Unit::TestCase

  # 日付文字列の走査
  # Dateオブジェクトとの関連はなく単純に配列を返すだけ
  # 日付と曜日が一致しなくてもそのまま返す
  # 下二桁の指定しか無い場合は引数に true を指定すると 1900 を加算してくれる
  # Monday を例に Monkey と書いても月曜日と判定された
  test "parsedate" do
    assert_equal([2000,1,3,  3,   4,   5, "+0900", nil], ParseDate.parsedate("2000-01-03 03:04:05 +0900"))
    assert_equal([2000,1,3,nil, nil, nil,     nil, nil], ParseDate.parsedate("2000-01-03"))
    assert_equal([2000,1,3,  3,   4, nil,     nil, nil], ParseDate.parsedate("1/3/2000 T03:04"))
    assert_equal([  75,1,3,  3,   4, nil,     nil, nil], ParseDate.parsedate("1/3/75 3:04am"))
    assert_equal([2000,1,3,  3,   4, nil,     nil, nil], ParseDate.parsedate("1/3/75 3:04am", true))
    assert_equal([2000,1,3,  3,   4,   5,   "CST",   1], ParseDate.parsedate("Mon Jan 03 03:04:05 CST 2000"))
    assert_equal([  75,1,3,  3,   4,   5,   "GMT",   1], ParseDate.parsedate("Mon 03-Jan-75 03:04:05 GMT"))
    assert_equal([2000,1,3,  3,   4,   5,   "GMT",   1], ParseDate.parsedate("Mon 03-Jan-75 03:04:05 GMT", true))
    assert_equal([2000,1,3,  3,   4, nil,   "WET", nil], ParseDate.parsedate("03-January-2000, 03:04 WET"))
    assert_equal([  75,1,3,nil, nil, nil,     nil, nil], ParseDate.parsedate("1/3/75"))
    assert_equal([2000,1,3,nil, nil, nil,     nil, nil], ParseDate.parsedate("3rd January, 2000"))
    assert_equal([  75,1,3,nil, nil, nil,     nil, nil], ParseDate.parsedate("January 3rd, 75"))
    assert_equal([2000,1,3,nil, nil, nil,     nil, nil], ParseDate.parsedate("January 3rd, 75", true))
    assert_equal([nil,nil,nil,nil, nil, nil,  nil,   1], ParseDate.parsedate("Monday"))
    assert_equal([nil,nil,nil,nil, nil, nil,  nil,   1], ParseDate.parsedate("Monkey"))
    assert_equal([nil,nil,nil,3,  4,   5,     nil, nil], ParseDate.parsedate("03:04:05"))
  end
end
