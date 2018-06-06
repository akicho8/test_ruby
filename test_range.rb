require "./test_helper"

class TestRange < Test::Unit::TestCase
  test "basic" do
    assert_equal([1,2,3], ((1..3).to_a))
    assert_equal([1,2,3], ((1...4).to_a))
    assert_equal(["aa", "ab", "ac"], (("aa".."ac").to_a))
  end
  test "s_new" do
    assert_equal([1,2,3], Range.new(1,3).to_a)
    assert_equal([1,2,3], Range.new(1,3,false).to_a)
    assert_equal([1,2,3], Range.new(1,4,true).to_a)
  end
  test "eq_x3" do
    x  = case 7
    when 1..5 then "x"
    when 6..9 then "y"
    end
    assert_equal("y", x)
  end
  test "begin_end_first_last" do
    assert_equal(1, (1..3).begin)
    assert_equal(3, (1..3).end)
    assert_equal(1, (1...3).begin)
    assert_equal(3, (1...3).end)

    assert_equal(1, (1..3).first)
    assert_equal(3, (1..3).last)
    assert_equal(1, (1...3).first)
    assert_equal(3, (1...3).last)
  end
  test "each" do
    x = []
    (1..3).each{|e|x << e}
    assert_equal([1,2,3], x)
  end
  test "collect" do		# map
    assert_equal([1,2,3], (1..3).collect {|i|i})
  end
  test "exclude_end?" do
    assert_equal(true, (1...3).exclude_end?) # 最後を含まない?
    assert_equal(false, (1..3).exclude_end?)
  end
  test "length_size" do
    assert_equal(26, ("a".."z").length) if RUBY_VERSION <= "1.6"
    assert_equal(26, ("a".."z").to_a.length) if RUBY_VERSION >= "1.8"
    assert_equal(26, ("a".."z").size) if RUBY_VERSION <= "1.6"
    assert_equal(26, ("a".."z").to_a.size) if RUBY_VERSION >= "1.8"
  end
end
