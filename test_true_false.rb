require "test/unit"

class TestTrueFalse < Test::Unit::TestCase
  test "true, false" do
    assert_equal("TrueClass", true.class.name)
    assert_equal("FalseClass", false.class.name)
    assert_equal(20, true.object_id)
    assert_equal(0, false.object_id)

    # assert_equal(true, TRUE) # !> constant ::TRUE is deprecated
    # assert_equal(false, FALSE) # !> constant ::FALSE is deprecated

    assert_equal(false, false.clone) # 昔は false.clone で TypeError になっていたがエラーにならなくなった★
    assert_equal(false, false.dup)

    assert_equal(false, false & true)
    assert_equal(false, false ^ false)
    assert_equal(true, false ^ true)
    assert_equal(true, false | true)
    assert_equal(false, false | false)
  end
end
