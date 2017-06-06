require "test/unit"

class TestString < Test::Unit::TestCase
  sub_test_case "class_methods" do
    test "new" do
      assert_equal("", String.new)

      # 巨大な文字列になるのがわかっている場合は、あらかじめ capacity を大きくしておくとオーバーヘッドを軽減できる
      require "objspace"
      assert_equal(168, ObjectSpace.memsize_of(String.new(capacity: 1)))
      assert_equal(10041, ObjectSpace.memsize_of(String.new(capacity: 10000)))
    end

    # 仰々しい名前だが「文字列のものだけを選別」と考えれば早い
    test "try_convert" do
      assert_nil(String.try_convert(nil))
      assert_nil(String.try_convert(0))
      assert_nil(String.try_convert([]))
      assert_nil(String.try_convert({}))
      assert_equal("", String.try_convert(""))

      # to_str で反応できるやつは変換
      assert_equal("ok", String.try_convert(Object.new.tap { |e| def e.to_str; "ok"; end }))
    end
  end

  test "sprintf" do
    assert_equal("00001010", "%08b" % 10)        # 全部で8桁
    assert_equal("0b001010", "%#08b" % 10)       # 「#」は「0b や 0x」がつく。それを含めて8桁

    assert_equal("+1", "%+d" % 1)                # 符号の幅を考慮したいときはこのようにしがちだけど
    assert_equal(" 1", "% d" % 1)                # "+" は表示したくない場合はスペースが便利

    assert_equal("01", "%.2s" % "012")           # truncate的なことが可能

    assert_equal("{:a=>0}", "%p" % {a: 0})       # inspect

                                                 # 引数を上手に選択する方法
    assert_equal("b a", "%2$s %1$s" % [:a, :b])  # 2$ で2番目
    assert_equal("ap", "%{foo}p" % {foo: :a})    # キーワード指定
    assert_equal(":a", "%<foo>p" % {foo: :a})    # キーワード指定(書式の影響あり)
  end
end
# >> Loaded suite -
# >> Started
# >> ...
# >> 
# >> Finished in 0.001294 seconds.
# >> ------
# >> 3 tests, 18 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> ------
# >> 2318.39 tests/s, 13910.36 assertions/s
