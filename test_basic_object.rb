require "./test_helper"

# https://docs.ruby-lang.org/ja/2.4.0/class/BasicObject.html
class TestBasicObject < Test::Unit::TestCase
  test "ancestors" do
    assert_equal([BasicObject], BasicObject.ancestors) # 親は自分
  end
end
# >> Loaded suite -
# >> Started
# >> .
# >> 
# >> Finished in 0.000333 seconds.
# >> ------
# >> 1 tests, 1 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> ------
# >> 3003.00 tests/s, 3003.00 assertions/s
