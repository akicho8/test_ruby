require "test/unit"

# https://docs.ruby-lang.org/ja/2.4.0/class/Struct.html
class TesStruct < Test::Unit::TestCase
  sub_test_case "class_methods" do
    test "ancestors" do
      # require "json" で変わってしまう
      # assert_equal([Struct, Enumerable, Object, Kernel, BasicObject], Struct.ancestors)
    end

    test "new" do
      assert_equal("Struct::Foo", Struct.new("Foo", :x).name) # Struct の下にできる
      assert_nil(Struct.new(:x).name) # 昔は "" だったが nil になった★
      assert_raise(ArgumentError) { Struct.new } # 引数ない構造体を認めないのはおかしい

      # 定数に割り当てた瞬間に名前が確定する
      s = Struct.new(:x)
      assert_nil(s.name)
      C = s
      assert_equal("TesStruct::C", s.name)
      # さらに別の定数に設定しても決まった定数は変わらない
      D = s
      assert_equal("TesStruct::C", s.name)
    end
  end

  test "[]" do
    assert_equal("#<struct x=:a>", Struct.new(:x)[:a].inspect)
  end

  test "members" do
    assert_equal([:x, :y], Struct.new(:x, :y).members) # 昔は文字列だったがシンボルになった
  end

  # test "=="
  #   k = Struct.new(:x, :y)
  #   x = k.new(1, 2)
  #   y = k.new(1, 2)
  #   assert_equal(true, x == y)
  # end

  #
  # def test_AREF
  #   x = Struct.new(:x, :y).new(1, 2)
  #   assert_equal(1, x[:x])
  #   assert_equal(1, x["x"])
  #   assert_equal(1, x[0])
  #   assert_equal(1, x.x)
  # end
  #
  # def test_each
  #   s = []
  #   x = Struct.new(:x, :y).new(1, 2)
  #   x.each {|e| s << e}
  #   assert_equal([1, 2], s)
  # end
  #
  # def test_length
  #   assert_equal(2, Struct.new(:x, :y).new(1, 2).size)
  # end
  #
  # def test_members
  #   assert_equal([:x, :y], Struct.new(:x, :y).new(1, 2).members)
  # end
  #
  # def test_to_a
  #   assert_equal([1, 2], Struct.new(:x, :y).new(1, 2).to_a)
  #   assert_equal([1, 2], Struct.new(:x, :y).new(1, 2).values)
  # end
end
# >> Loaded suite -
# >> Started
# >> ....
# >> 
# >> Finished in 0.001171 seconds.
# >> ------
# >> 4 tests, 8 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> ------
# >> 3415.88 tests/s, 6831.77 assertions/s
