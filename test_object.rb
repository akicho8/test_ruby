require "./test_helper"

class TestObject < Test::Unit::TestCase
  test "new" do
    assert { Object.new }
  end
end
# >> Loaded suite -
# >> Started
# >> .
# >> Finished in 0.008037 seconds.
# >> -------------------------------------------------------------------------------
# >> 1 tests, 1 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 124.42 tests/s, 124.42 assertions/s
