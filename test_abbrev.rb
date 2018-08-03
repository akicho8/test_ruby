require "./test_helper"
require "abbrev"

class TestAbbrev < Test::Unit::TestCase
  test "abbrev" do
    assert { ["foo", "bar"].abbrev == {"foo"=>"foo", "fo"=>"foo", "f"=>"foo", "bar"=>"bar", "ba"=>"bar", "b"=>"bar"} }
  end
end
# >> Loaded suite -
# >> Started
# >> .
# >> Finished in 0.006345 seconds.
# >> -------------------------------------------------------------------------------
# >> 1 tests, 1 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 157.60 tests/s, 157.60 assertions/s
