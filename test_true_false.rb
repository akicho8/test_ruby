require "./test_helper"

class TestTrueFalse < Test::Unit::TestCase
  test "true, false" do
    assert_equal("TrueClass", true.class.name)
    assert_equal("FalseClass", false.class.name)
    assert_equal(20, true.object_id)
    assert_equal(0, false.object_id)

    assert_equal(true, TRUE)
    assert_equal(false, FALSE)

    assert_equal(false, false.clone) # 昔は false.clone で TypeError になっていたがエラーにならなくなった★
    assert_equal(false, false.dup)

    assert_equal(false, false & true)
    assert_equal(false, false ^ false)
    assert_equal(true, false ^ true)
    assert_equal(true, false | true)
    assert_equal(false, false | false)
  end
end
# >> Loaded suite -
# >> Started
# >> .
# >> Finished in 0.000532 seconds.
# >> -------------------------------------------------------------------------------
# >> 1 tests, 13 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 1879.70 tests/s, 24436.09 assertions/s
