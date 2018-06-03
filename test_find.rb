require "./test_helper"

require "find"

class TestFind < Test::Unit::TestCase
  test "find" do
    files = []
    Find.find("/bin") {|f|files << f}
    assert_equal(true, 1 <= files.size)
  end
  test "prune" do
    files = []
    Find.find("/bin", "/etc") {|f|
      Find.prune if f == "/etc"	# /etc の走査はスキップ
      files << f
    }
    assert_equal(true, 1 <= files.size)
  end
end
# >> Loaded suite -
# >> Started
# >> ..
# >> Finished in 0.001846 seconds.
# >> -------------------------------------------------------------------------------
# >> 2 tests, 2 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 1083.42 tests/s, 1083.42 assertions/s
