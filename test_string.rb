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

  test "sprintf" do
    assert_equal("0b001010", "%#08b" % 10) # 0b も含めて8桁

    assert_equal("+1", "%+d" % 1) # 符号の幅を考慮したいときはこのようにしがちだけど
    assert_equal(" 1", "% d" % 1) # "+" は表示したくない場合はスペースが便利

    assert_equal("01", "%.2s" % "012") # 「切り捨て」

    assert_equal("{:a=>1}", "%p" % {a: 1}) # inspect
  end
end
# >> Loaded suite -
# >> Started
# >> ...
# >> 
# >> Finished in 0.001303 seconds.
# >> ------
# >> 3 tests, 8 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> ------
# >> 2302.38 tests/s, 6139.68 assertions/s
