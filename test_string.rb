require "./test_helper"

# https://docs.ruby-lang.org/ja/2.4.0/class/String.html
class TestString < Test::Unit::TestCase
  sub_test_case "class_methods" do
    test "ancestors" do
      # require "json" で変わってしまう
      # assert_equal([String, Comparable, Object, Kernel, BasicObject], String.ancestors)
    end

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
    assert_equal(" 1", "% d" % 1)                # "+" は表示したくない場合はスペースが便利★

    assert_equal("01", "%.2s" % "012")           # truncate的なことが可能

    assert_equal("{:a=>0}", "%p" % {a: 0})       # inspect ★

    # 引数を上手に選択する方法
    assert_equal("b a", "%2$s %1$s" % [:a, :b])  # 2$ で2番目★
    assert_equal("ap", "%{foo}p" % {foo: :a})    # キーワード指定
    assert_equal(":a", "%<foo>p" % {foo: :a})    # キーワード指定(書式の影響あり)★
  end

  test "*" do
    assert_equal("aaa", "a" * 3)
  end

  test "+" do
    assert_equal("ab", "a" + "b")
    assert_equal(false, ("".freeze + "").frozen?) # 空文字列を足すと freeze 解除
    assert_equal(false, ("" + "".freeze).frozen?) # 空文字列を足すと freeze 解除
  end

  test "+符号で非破壊的な解凍" do # そもそも破壊的な解凍ってあるの？
    a = ""
    a.freeze
    assert_equal(true, a.frozen?)
    assert_equal(false, (+a).frozen?)     # +a で freeze が外れる★
    assert_equal(false, (a + "").frozen?) # これは空文字列を足すのと同じだけど「+」の方がスマート
    assert_equal(true, a.frozen?)
  end

  test "-符号で非破壊的な冷凍" do
    a = ""
    assert_equal(false, a.frozen?)
    assert_equal(true, (-a).frozen?) # -a で freeze する★
    assert_equal(false, a.frozen?)   # 元は破壊されていないことがわかる
  end

  test "concat, <<" do
    v = ""
    id = v.object_id
    assert_equal("", v.concat)
    assert_equal("a", v.concat("a"))
    assert_equal("abc", v.concat("b", "c")) # concat だと複数指定できる
    assert_equal("abcd", v << "d".ord)
    assert_equal(id, v.object_id) # 破壊的なのでオブジェクトIDは変化ていない
  end

  test "<=>" do
    assert_equal(65, "A".ord)
    assert_equal(66, "B".ord)
    assert_equal(-1, "A" <=> "B") # 65 - 66
    assert_equal(+1, "B" <=> "A") # 66 - 65
    assert_equal( 0, "A" <=> "A") # 65 - 65
    if false
      $old = $=
      $= = true # 大文字小文字区別無し
      assert_equal(0, "A" <=> "a")
      $= = $old
    end
  end

  # TODO: 仕様が難しいのであとまわし
  test "==, ===" do
    assert_equal(true, "x" == "x")
    assert_equal(true, "x" === "x")
  end

  # Perl由来の気持ち悪いメソッド
  test "=~" do
    assert_equal(1, "foo" =~ /o/)            # これはインデックスを返すことがわかりにくい。そのうえインデックスとしては使うことはほとんどない
    assert_raise(TypeError) { "foo" =~ "o" } # 文字列を自動的に正規表現にしてくたりはしない
  end

  test "[], slice" do
    assert_equal(?a, "a"[0])    # ?a でなく "a" が返るのに、なぜ ?a と一致するのか疑問に思うかもしれないけど、?a 自体が "a" なのだった
    assert_equal("a", ?a)
    assert_equal("a", ?a)       # やっぱり ?a は "a" だった

    # だからといって ?AB とするとこうなる
    # warning: `?' just followed by `AB' is interpreted as a conditional operator, put a space after `?'
    # syntax error, unexpected '?', expecting keyword_end

    # 他の使い方
    assert_equal("bc", "abcd"[1..2]) # 範囲指定
    assert_equal("bc", "abcd"["bc"]) # strstr風の使い方
    assert_equal("bc", "abcd"[/bc/]) # 正規表現の場合
  end

  test "[なんでもいい] = v" do
    # slice で使える引数はなんでも通るっぽい
    v = "ABAB"; v[1] = ?_;    assert_equal("A_AB", v)
    v = "ABAB"; v[1..1] = ?_; assert_equal("A_AB", v)
    v = "ABAB"; v["B"] = "_"; assert_equal("A_AB", v) # sub と同じ
    v = "ABAB"; v[/B/] = "_"; assert_equal("A_AB", v) # sub と同じ

    # insert のインデックスは数字に限られているため、こっちの方が汎用性が高そう
    assert_raise(TypeError) { "ABAB".insert(/B/, "_") }
  end

  test "capitalize" do
    assert_equal("Foo_bar", "foo_bar".capitalize)
    assert_equal("Foo_bar", "foo_bar".tap(&:capitalize!))
  end

  #   test "center
  #     assert_equal(" A ", "A".center(3))
  #   end
  #   test "chomp
  #     assert_equal("A", "A".chomp)
  #     assert_equal("A", "A\n".chomp)
  #     assert_equal("A", (x="A\n"; x.chomp!))
  #   end
  #   test "chop
  #     assert_equal("A", "ABC".chop.chop)
  #     assert_equal("A", "A\r\n".chop)
  #     assert_equal("A\n", "A\n\r".chop) # \n\rの場合は \r のみ削除
  #     assert_equal("", (x="A"; x.chop!; x))
  #   end
  #   test "concat
  #     assert_equal("AB", "A".concat("B"))
  #     assert_equal("AB", "A" <<     "B")
  #   end
  #   test "count
  #     assert_equal(1, "A".count("A"))
  #     assert_equal(2, "AA".count("A"))
  #     assert_equal(3, "ABC".count("A-C"))
  #     assert_equal(2, "ABC".count("^A"))
  #   end
  #   test "crypt
  #     assert_equal("AB4esoRQkR5vM", "hello".crypt("AB"))
  #     assert_equal("AB4esoRQkR5vM", "hello".crypt("ABC")) # 2文字しか使わないのでそれ以上設定しても関係無い
  #   end
  #   test "delete               # countと同じ規則で削除
  #     assert_equal("a", "abc".delete("bc"))
  #     assert_equal("b", "abc".delete("ac"))
  #     assert_equal("c", "abc".delete("^c"))
  #     assert_equal("a", (x="abc"; x.delete!("bc")))
  #   end
  #   test "downcase
  #     assert_equal("abc", "AbC".downcase)
  #     assert_equal("abc", (x="AbC"; x.downcase!))
  #   end
  #   test "dump
  #     assert_equal("\"\\a\"", ("%c"%7).dump)
  #   end
  #   test "each                 # each_line
  #     x=[]; "ABAB"      .each("B") {|e|x<<e}; assert_equal(["AB",   "AB"   ], x)
  #     x=[]; "A\nA\n"    .each      {|e|x<<e}; assert_equal(["A\n",  "A\n"  ], x)
  #     x=[]; "A\r\nA\r\n".each      {|e|x<<e}; assert_equal(["A\r\n","A\r\n"], x)
  #     x=[]; "A\r\nA\r\n".each("\n"){|e|x<<e}; assert_equal(["A\r\n","A\r\n"], x)
  #   end
  #   test "each_byte
  #     x=[]; "\r\n".each_byte{|e|x<<e}; assert_equal([13,10], x)
  #   end
  #   test "empty?
  #     assert_equal(true, "".empty?)
  #   end
  #   test "gsub
  #     assert_equal("<foo>bar<foo>bar", "foobarfoobar".gsub(/(foo)/, '<\1>'))
  #     x="AB"; x.gsub!(/A/, "X"); assert_equal("XB", x)
  #   end
  #   test "hash
  #     assert_equal(833038373, "abc".hash)
  #   end
  #   test "hex
  #     assert_equal(10, "0xa".hex)
  #     assert_equal(10,   "a".hex)
  #     assert_equal(0,     "".hex)
  #     assert_equal(0,    "G".hex)
  #   end
  #   test "include?
  #     assert_equal(true, "abc".include?("a"))
  #     assert_equal(true, "abc".include?("ab"))
  #     assert_equal(false,"abc".include?("x"))
  #     assert_equal(true,"a[b]c".include?("[b]"))
  #   end
  #   test "index
  #     assert_equal(1, "abc".index(?b))
  #     assert_equal(1, "abc".index("b"))
  #     assert_equal(1, "abc".index(/b/))
  #     assert_equal(1, "bbc".index("b",1))
  #   end
  #   test "intern
  #     assert_equal(:a, "a".intern)
  #   end
  #   test "length               # size
  #     assert_equal(1, "a".length)
  #   end
  #   test "ljust
  #     assert_equal("a ", "a".ljust(2))
  #     assert_equal("あ  ", "あ".ljust(4))
  #   end
  #   test "next                 # next! succ succ!
  #     assert_equal("b", "a".next)
  #     assert_equal("b", (x="a"; x.next!))
  #   end
  #   test "oct
  #     assert_equal(10, "12".oct)
  #     assert_equal(10, "012".oct)
  #     assert_equal(0, "".oct)
  #   end
  #   test "replace
  #     x = "A"
  #     id = x.object_id
  #     x.replace("B")
  #     assert_equal(id, x.object_id)
  #   end
  #   test "reverse
  #     assert_equal("cba", "abc".reverse)
  #     assert_equal("cba", (x="abc"; x.reverse!; x))
  #   end
  #   test "rindex
  #     assert_equal(3, "abcabc".rindex("a"))
  #   end
  #   test "rjust
  #     assert_equal(" a", "a".rjust(2))
  #   end
  #   test "scan
  #     assert_equal(["a","a"], "abab".scan(/a/))
  #   end
  #   test "slice
  #     x = "foobar"
  #     assert_equal("bar", x.slice!(/bar/))
  #     assert_equal("foo", x)
  #   end
  #   test "split
  #     assert_equal(["a","b","c"], "abc".split(//))
  #     assert_equal(["a","bc"], "abc".split(//, 2))
  #   end
  #   test "squeeze
  #     assert_equal("abc", "aabbcc".squeeze)
  #     assert_equal("abc", (x="aabbcc"; x.squeeze!; x))
  #   end
  #   test "strip
  #     assert_equal("a", " a \r\n".strip)
  #     assert_equal("a", (x=" a \r\n"; x.strip!; x))
  #   end
  #   test "sub
  #     assert_equal("xb", "ab".sub(/a/, "x"))
  #     assert_equal("xb", (x="ab"; x.sub!(/a/,"x"); x))
  #   end
  #   test "sum
  #     assert_equal(294, "abc".sum)
  #   end
  #   test "swapcase
  #     assert_equal("aBc", "AbC".swapcase)
  #     assert_equal("aBc", (x="AbC"; x.swapcase!; x))
  #   end
  #   test "to_f
  #     assert_equal(12.34, "12.34".to_f)
  #   end
  #   test "to_i
  #     assert_equal(12, "12".to_i)
  #   end
  #   test "to_s                 # to_str
  #     assert_equal("ab", "ab".to_s)
  #   end
  #   test "tr
  #     assert_equal("xyyz", "abbc".tr("a-c", "x-z"))
  #   end
  #   test "tr_s
  #     assert_equal("xyz", "abbc".tr_s("a-c", "x-z"))
  #     assert_equal("xyz", (x="abbc"; x.tr_s!("a-c", "x-z"); x))
  #   end
  #   test "unpack
  #     assert_equal([13, 10], "\r\n".unpack("c*"))
  #   end
  #   test "upcase
  #     assert_equal("ABC", "aBc".upcase)
  #     assert_equal("ABC", (x="aBc"; x.upcase!; x))
  #   end
  #   test "upto
  #     x = []
  #     "a".upto("c"){|e|x<<e}
  #     assert_equal(["a", "b", "c"], x)
  #   end

end
# >> Loaded suite -
# >> Started
# >> .........F
# >> ===============================================================================
# >> Failure: test: capitalize(TestString)
# >> -:140:in `block in <class:TestString>'
# >> <"Foo_bar"> expected but was
# >> <"foo_bar">
# >> 
# >> diff:
# >> ? Foo_bar
# >> ? f      
# >> ===============================================================================
# >> .....
# >> 
# >> Finished in 0.010933 seconds.
# >> ------
# >> 15 tests, 56 assertions, 1 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 93.3333% passed
# >> ------
# >> 1371.99 tests/s, 5122.11 assertions/s
