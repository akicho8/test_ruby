require "./test_helper"

# https://docs.ruby-lang.org/ja/2.4.0/class/Array.html
class TestArray < Test::Unit::TestCase
  test "s_AREF" do
    assert_equal([1, 'a', /^A/], Array.[](1, 'a', /^A/))
    assert_equal([1, 'a', /^A/], Array[1, 'a', /^A/])
    assert_equal([1, 'a', /^A/], [1, 'a', /^A/])
  end

  test "new" do
    assert_equal([], Array.new)
    assert_equal([nil, nil], Array.new(2))
    assert_equal(["A", "A"], Array.new(2, "A"))
    assert_equal([{}, {}], Array.new(2, Hash.new))
    assert_equal([{}, {}], Array.new(2, {}))

    # 初期値を与えた場合すべて同じオブジェクトになる
    x = Array.new(2, Object.new)
    assert(x[0].object_id == x[1].object_id)

    # 初期値をことなる要素にしたい場合のダメな書き方
    x = (0...2).collect{Object.new}
    assert(x[0].object_id != x[1].object_id)

    # 初期値をことなる要素にしたい場合の良い書き方
    x = Array.new(2){Object.new}
    assert(x[0].object_id != x[1].object_id)
  end

  test "and_mark" do
    assert_equal([3,4], [1,2,3,4] & [3,4,5,6])
    assert_equal([], [1,2,3,4] & [])
  end

  test "or_mark" do
    assert_equal([1,2,3,4], [1,2,3] | [2,3,4])
    assert_equal([1,2,3,4], [1,2,3] | [2,2,3,3,4,4])
    assert_equal([1,2,3,4], [1,1,2,2,3,3,4,4] | [])
  end

  test "multi_mark" do
    assert_equal([1,2,1,2], [1,2] * 2)
    assert_equal([], [1,2] * 0)
  end

  test "plus_mark" do
    assert_equal([1,2,3,4], [1,2] + [3,4])
    assert_equal([1,2,3,4], [1,2].concat([3,4]))
  end

  test "sub_mark" do
    assert_equal([1,2], [1,2,3,4] - [3,4])
    assert_equal([], [] - [3,4])
  end

  test "push_mark" do
    assert_equal([1,2,[3,4],5,[]], [1] << 2 << [3,4] << 5 << [])
  end

  test "compare_mark" do
    assert_equal(+0, [1,2] <=> [1,2])
    assert_equal(+1, [1,2] <=> [1,1])
    assert_equal(-1, [1,2] <=> [1,3])
    assert_equal(-1, [1,2] <=> [1,2,3])
  end

  test "equal_mark" do
    assert_equal(true, Array.new == Array.new)
    assert_equal(true, [1,2] == [1,2])
    assert_equal(false, [1,2] == [1,2,3])
  end

  test "case_equal_mark" do
    assert_equal(true, Array.new === Array.new)
    assert_equal(true, [1,2] === [1,2])
    assert_equal(false, [1,2] === [1,2,3])

  end
  test "AREF" do
    assert_equal("A", ["A","B"][0])
    assert_equal("B", ["A","B"][1])
    assert_equal(nil, ["A","B"][2])
    assert_equal("B", ["A","B"][-1])
    assert_equal("A", ["A","B"][-2])
    assert_equal(nil, ["A","B"][-3])
    assert_equal(["A", "B"], ["A","B"][0,2]) # [offset, limit] のように意識してアクセスできる。
    assert_equal("A", ["A","B"].slice(0))
    assert_equal("B", ["A","B"].slice(1))
  end

  test "ASET" do
    assert_raises(IndexError) {[][-1]=nil}

    x = [0,1,2,3]
    x[1,2] = [10,20,30]
    assert_equal([0,10,20,30,3], x)
    x = [0,1,2,3]
    x[1,2] = [10]
    assert_equal([0,10,3], x)
    x = [0,1,2,3]
    x[1..2] = [10]
    assert_equal([0,10,3], x)
    x = [0,1,2,3]
    x[1...3] = [10]
    assert_equal([0,10,3], x)
  end

  test "assoc" do
    x = [
      [1,2,3],
      [4,5,6],
      [7,8,9],
    ]
    assert_equal([1,2,3], x.assoc(1))
    assert_equal(nil, x.assoc(0))
    assert_equal([1,2,3], x.rassoc(2))
    assert_equal(nil, x.rassoc(0))
  end

  test "at" do
    assert_equal(1,   [1].at(0))
    assert_equal(1,   [1].at(-1))
    assert_equal(nil, [1].at(1))
    assert_equal(nil, [1].at(-2))
  end

  test "clear" do
    assert_equal([], [1,2].clear)
  end

  test "collect" do
    assert_equal([4,6], [2,3].collect{|e|e*2})
    assert_equal([4,6], [2,3].map{|e|e*2})
    assert_equal([nil,nil], [2,3].collect{nil})
    assert_equal([nil,nil], [2,3].collect{})
    assert_kind_of(Enumerator, [2,3].collect)
    assert_equal("#<Enumerator: [2, 3]:collect>", [2,3].collect.inspect)
  end

  test "collect!" do
    x = [2,3]
    x.collect!{|e|e*2}
    assert_equal([4,6], x)
  end

  test "compact" do
    x = [1,nil,2,nil,3]
    y = x.compact
    assert_equal([1,nil,2,nil,3], x)
    assert_equal([1,2,3], y)
    x.compact!
    assert_equal([1,2,3], x)
  end

  test "delete" do
    x = [1,2,2,4]
    assert_equal(2, x.delete(2))
    assert_equal([1,4], x)
    assert_equal(nil, x.delete(5))
    assert_equal(6,   x.delete(5){6})
  end

  test "delete_at" do
    x = [1,2,3,4]
    assert_equal(2, x.delete_at(1))
    assert_equal([1,3,4], x)
    assert_equal(nil, x.delete_at(4))
  end

  test "delete_if" do             # 削除する要素が無い場合でもselfを返す。reject!はnil
    x = [1,2,3,4]
    assert_equal([1,3], x.delete_if {|e|(e % 2) == 0})
    assert_equal([1,3], x)
  end

  test "each" do
    x = [1,2,3]
    y = []
    assert_equal([1,2,3], x.each{|e| y << e})
    assert_equal([1,2,3], y)
  end

  test "each_index" do
    x = ["A","B","C"]
    y = []
    x.each_index{|i| y << i}
    assert_equal([0,1,2], y)
  end

  test "empty?" do
    assert_equal(true, [].empty?)
    assert_equal(false, [1].empty?)
  end

  test "eql?" do
    assert_equal(true, [1,2].eql?([1,2]))
    assert_equal(false, [1,2].eql?([1,2,3]))
  end

  test "fill" do
    assert_equal([0,0,0,0], [1,2,3,4].fill(0))
    assert_equal([1,0,0,4], [1,2,3,4].fill(0,1,2))
    assert_equal([1,0,0,4], [1,2,3,4].fill(0,1..2))
    assert_equal([1,0,0,4], [1,2,3,4].fill(0,1...3))
  end

  test "first_last" do
    assert_equal(1, [1,2,3].first)
    assert_equal(3, [1,2,3].last)
    assert_equal([1,2], [1,2,3].first(2)) # 個数を指定できる
    assert_equal([2,3], [1,2,3].last(2))
    assert_equal(nil, [].first)
    assert_equal(nil, [].last)
  end

  test "flatten" do
    x = [[1,2],[3,4]]
    assert_equal([1,2,3,4], x.flatten)
    assert_equal([[1,2],[3,4]], x)
    x.flatten!
    assert_equal([1,2,3,4], x)
  end

  test "include?" do
    x = [1,[2]]
    assert_equal(false, x.include?(0))
    assert_equal(true, x.include?(1))
    assert_equal(false, x.include?(2))
    assert_equal(true, x.include?([2]))
  end

  test "index" do
    x = %w(A B A)
    assert_equal(0, x.index("A"))
    assert_equal(1, x.index("B"))
    assert_equal(nil, x.index("C"))
    assert_equal(2, x.rindex("A"))
  end

  if RUBY_VERSION <= "1.6"
    test "indexes" do
      x = [10,20,30]
      assert_equal([10,30], x.indexes(0,2))
      assert_equal([10,30], x.indices(0,2))
      assert_equal([30,30,nil], x.indexes(-1,-1,3))
    end
  end

  test "join" do
    x = [1,2,3]
    assert_equal("1-2-3", x.join("-"))
    assert_equal("123", x.join)
    assert_equal("", [].join("-"))
  end

  if RUBY_VERSION < "2.0"
    test "nitems" do
      assert_equal(1, [1,nil].nitems)
      assert_equal(2, [1,nil,1].nitems)
      assert_equal(0, [].nitems)
    end
  end

  test "pack" do
    assert_equal("x ", ["x"].pack("A2"))
    assert_equal("x\000", ["x"].pack("a2"))
    assert_equal("ABC", [65,66,67].pack("ccc"))
    assert_equal(["1"], [1].pack("M").unpack("M"))
  end

  #--------------------------------------------------------------------------------

  test "push" do
    x = []
    assert_equal([1], x.push(1))
    assert_equal([1,2,3], x.push(2,3))
  end

  test "pop" do
    x = [1,2]
    assert_equal(2, x.pop)
    assert_equal([1], x)
    assert_equal(nil, [].pop)
  end

  test "shift" do
    x = [1,2,3]
    assert_equal(1, x.shift)
    assert_equal([2,3], x)
  end

  test "unshift" do
    assert_equal([1,2], [2].unshift(1))
    assert_equal([1,2,3], [3].unshift(1,2))
  end

  #--------------------------------------------------------------------------------

  test "reject!" do # 削除する要素が無い場合はnilを返す
    x = [1,2,3]
    assert_equal([1,3], x.reject!{|e|e == 2})
    x = [1,2,3]
    assert_equal([], x.reject!{true})
    x = [1,2,3]
    assert_equal(nil, x.reject!{false})
  end

  test "replace" do
    x = [1,2]
    id = x.object_id
    x.replace([3,4])
    assert_equal(true, id == x.object_id)
  end

  test "reverse" do
    x = [1,2,3]
    y = x.reverse
    assert_equal([3,2,1], y)
    assert_equal([1,2,3], x)
    x.reverse!
    assert_equal([3,2,1], x)
  end

  test "size_length" do
    assert_equal(2, [1,2].size)
    assert_equal(2, [1,2].length)
  end

  test "slice!" do
    x = [1,2,3,4]
    assert_equal([2,3], x.slice!(1..2))
    assert_equal([1,4], x)
  end

  test "sort" do
    x = [4,1,3,2]
    assert_equal([1,2,3,4], x.sort)
    assert_equal([1,2,3,4], x.sort{|a,b|a <=> b})
    assert_equal([4,3,2,1], x.sort{|a,b|b <=> a})
    x.sort!
    assert_equal([1,2,3,4], x)
  end

  test "sort_by" do
    x = ["a", "B", "c"]
    assert_equal(["B", "a", "c"], x.sort)
    assert_equal(["a","B","c"], x.sort_by{|v|v.downcase}) # 要素をソートのときだけ変換できる
  end

  test "to_ary" do
    assert_equal([1,2], [1,2].to_a)
    assert_equal([1,2], [1,2].to_ary)
  end

  test "to_s" do
    assert_equal("[1, 2]", [1,2].to_s)
  end

  test "uniq" do
    x = [1,2,1,2]
    y = x.uniq
    assert_equal([1,2], y)
    assert_equal([1,2,1,2], x)
    x.uniq!
    assert_equal([1,2], x)
  end

  #--------------------------------------------------------------------------------

  # 要素がすべてifを通るか?
  #
  # 以下と同じ
  # a = [1,nil,false,1]
  # p a.find_all{|e|e} == a
  #
  test "all" do
    assert_equal(true, [1,2,3].all?)
    assert_equal(false, [1,nil,false,1].all?)
    assert_equal(true, [1,2,3].all?{|v|v >= 1})
    assert_equal(false, [1,2,3].all?{|v|v >= 2})
  end

  # 要素がすべてelseになるか?
  test "any" do
    assert_equal(false, [nil,false].any?)
    assert_equal(true, [1,nil,false,1].any?)
  end

  # sum += v するとき専用
  test "injext" do
    assert_equal(6, [1,2,3].inject{|sum, v| sum += v})
  end

  # 配列と配列を直角に混ぜる
  test "zip" do
    assert_equal([[1,4],[2,5],[3,6]], [1,2,3].zip([4,5,6]))

    # DBで取得した値にタイトルを付けたい
    assert_equal([["id", 1], ["count", 100]], ["id", "count"].zip([1, 100]))
  end

  # true と false でグループ化
  test "partition" do
    assert_equal([["bar", "baz"], ["foo"]],  ["foo", "bar", "baz"].partition{|v|v[/a/]})
  end

  test "bsearch" do
    assert_equal("c", %w(a b c d e).bsearch {|e| e >= "c"})      # find-minimum
    assert_equal("c", %w(a b c d e).bsearch {|e| e <=> "c"})     # find-any
  end

  test "bsearch_index" do
    assert_equal(2, %w(a b c d e).bsearch_index {|e| e >= "c"})  # find-minimum
    assert_equal(2, %w(a b c d e).bsearch_index {|e| e <=> "c"}) # find-any
  end
end
