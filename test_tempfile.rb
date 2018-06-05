


require "./test_helper"

require "tempfile"

class TestTempfile < Test::Unit::TestCase
  test "basic" do
    x = Tempfile.new("foo")
    assert_equal(true, File.exist?(x.path))
    x.print "OK"
    x.close			# 削除はしない
    assert_equal(2, File.size(x.path))

    x.open			# 再びオープン
    x.close(true)		# 閉じて削除する
    assert_equal(false, File.exist?(x.path))
  end
end
