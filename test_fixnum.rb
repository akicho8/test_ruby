require "./test_helper"

class TestFixnum < Test::Unit::TestCase
  test "s_superclass" do
    assert_equal("Numeric", Fixnum.superclass.name)
  end

  test "AREF" do
    x = ""
    4.times{|i|x << 10[i].to_s}
    assert_equal("0101", x)
    # assert_equal("0101", 10.to_s(2)) # 1.7 feture
  end

  test "id2name" do
    assert_raise(NoMethodError) { :foo.to_i } # 昔はできた
  end

  test "to_i" do
    assert_equal(123, 123.to_i)
  end

  test "to_s" do
    assert_equal("123", 123.to_s)
  end

  test "to_f" do
    assert_equal(123.0, 123.to_f)
  end

  test "size" do
    assert_equal(8, 0.size)
    assert_equal(8, 65536.size)
    assert_equal(8, 10000000000.size)
    assert_equal(9, 100000000000000000000.size)
    assert_equal(13, 10000000000000000000000000000000.size)
    assert_equal(37, 1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.size)
  end
end
