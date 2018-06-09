require "./test_helper"
require "ostruct"

# https://docs.ruby-lang.org/ja/latest/class/OpenStruct.html
class TestOStruct < Test::Unit::TestCase
  test ".new" do
    o = OpenStruct.new(a: 1)
    o.c = 3
    o[:d] = 4

    assert { o.a == 1 }
    assert { o.b == nil }
    assert { o.c == 3 }
    assert { o.d == 4 }
  end

  # どっちも同じ？
  test "==, eql?" do
    a = OpenStruct.new(a: 1)
    b = Class.new(OpenStruct).new(a: 1)
    assert { a == b }
    assert { a.eql?(b) }
  end

  test "delete_field" do
    o = OpenStruct.new(a: 1)
    o.delete_field(:a)
    assert { o.a == nil }
  end

  test "dig" do
    o = OpenStruct.new(a: OpenStruct.new(b: 1))
    assert { o.dig(:a, :b) == 1 }
  end

  test "each_pair" do
    o = OpenStruct.new(a: 1, b: 2)
    assert { o.each_pair.to_a == [[:a, 1], [:b, 2]] }
  end

  test "hash" do
    assert { OpenStruct.new.hash }
  end

  test "inspect, to_s" do
    o = OpenStruct.new(a: 1)
    assert { o.inspect == "#<OpenStruct a=1>" }
    assert { o.to_s == "#<OpenStruct a=1>" }
  end

  # ★ Hash が返るとドキュメントにはあるが実際は nil
  test "modifiable" do
    o = OpenStruct.new(a: 1)
    assert { o.modifiable == nil }

    # ★ 自身が Object#freeze されている場合にこのメソッドを呼び出すと例外が発生します → 発生しない
    o.freeze
    assert { o.modifiable == nil }
  end

  # Error: test: new_ostruct_member(TestOStruct): NoMethodError: protected method `new_ostruct_member' called for #<OpenStruct>
  test "new_ostruct_member" do
    o = OpenStruct.new
    assert_raise(NoMethodError) { o.new_ostruct_member(:a) }
  end

  test "to_h" do
    assert { OpenStruct.new(a: 1).to_h == {:a=>1} }
  end
end
