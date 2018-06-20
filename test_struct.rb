require "./test_helper"

# https://docs.ruby-lang.org/ja/2.5.0/class/Struct.html
class TestStruct < Test::Unit::TestCase
  test "Struct.new" do
    assert { Struct.new("Foo", :x).name == "Struct::Foo" }
    assert { Struct.new(:x).name == nil }
    assert_raise(ArgumentError) { Struct.new }
  end

  test "Struct.new(*args, keyword_init: true)" do
    # ★ いちばん欲しかったのはこれだった
    s = Struct.new(:x, :y, keyword_init: true)
    assert { s.new(x: 1, y: 2).inspect == "#<struct x=1, y=2>" }
    # 従来の使い方はできなくなる
    assert_raise(ArgumentError) { s.new(1, 2) }
  end

  test "定数に割り当てた瞬間に名前が確定する" do
    s = Struct.new(:x)
    assert { s.name == nil }
    C = s
    assert { s.name == "TestStruct::C" }
    # さらに別の定数に設定しても決まった定数は変わらない
    D = s
    assert { s.name == "TestStruct::C" }
  end

  test ".new, .[]" do
    s = Struct.new(:x, :y)
    o1 = s[1, 2]
    o2 = s.new(1, 2)
    assert { o1.inspect == "#<struct x=1, y=2>" }
    assert { o2.inspect == "#<struct x=1, y=2>" }
  end

  test "members" do
    assert { Struct.new(:x, :y).members == [:x, :y] }
  end

  test "==" do
    k = Struct.new(:x, :y)
    x = k.new(1, 2)
    y = k.new(1, 2)
    assert_equal(true, x == y)
  end

  test "[], []=" do
    s = Struct.new(:x).new(1)
    assert { s[:x] == 1 }
    assert { s["x"] == 1 }
    assert { s[0] == 1 }

    s[:x] = 2
    assert { s[0] == 2 }
  end

  test "each" do
    assert { Struct.new(:x, :y).new(1, 2).each.to_a == [1, 2] }
  end

  test "each_pair" do
    s = Struct.new(:x, :y).new(1, 2)
    assert { s.each_pair.to_a == [[:x, 1], [:y, 2]] }
  end

  test "length, size" do
    assert { Struct.new(:x, :y).new(1, 2).length == 2 }
  end

  test "values, to_a" do
    s = Struct.new(:x, :y).new(1, 2)
    assert { s.values == [1, 2] }
    assert { s.to_a == [1, 2] }
  end

  test "values_at" do
    s = Struct.new(:x, :y, :z).new(1, 2, 3)
    assert { s.values_at(0, 2) == [1, 3] }
    assert { s.values_at(0..1) == [1, 2] }

    # ★ キー指定できないのは使いづらい
    assert_raise(TypeError) { s.values_at(:x, :z) }

    # ★ keyword_init を使ってもキーではアクセスできない。これはいけてない。が、 これを望むなら普通に Hash を使った方がいい。
    s = Struct.new(:x, :y, :z, keyword_init: true).new(x: 1, y: 2, z: 3)
    assert_raise(TypeError) { s.values_at(:x, :z) }
  end

  test "to_h" do
    s = Struct.new(:x, :y).new(1, 2)
    assert { s.to_h == {:x => 1, :y => 2} }
  end

  test "select" do
    s = Struct.new(:x, :y).new(1, 2)
    assert { s.select(&:even?) == [2] }
  end

  test "hash" do
    s = Struct.new(:x, :y).new(1, 2)
    assert { s.hash.kind_of?(Integer) == true }
  end
end
