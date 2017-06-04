require 'test/unit'

class TestString < Test::Unit::TestCase
  sub_test_case 'class_methods' do
    test 'new' do
      assert_equal("", String.new)
    end

    test 'capacity option' do
      require 'objspace'
      assert_equal(168, ObjectSpace.memsize_of(String.new(capacity: 1)))
      assert_equal(10041, ObjectSpace.memsize_of(String.new(capacity: 10000)))
    end
  end
end
# >> Loaded suite -
# >> Started
# >> ..
# >> 
# >> Finished in 0.001196 seconds.
# >> ------
# >> 2 tests, 3 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> ------
# >> 1672.24 tests/s, 2508.36 assertions/s
