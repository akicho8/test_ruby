require "./test_helper"

# https://docs.ruby-lang.org/ja/latest/class/Enumerable.html
class TestEnumerable < Test::Unit::TestCase
  class Foo
    include Enumerable

    def initialize(v)
      @v = v
    end

    def each(&block)
      v.each(&block)
    end
  end

  # test "collect, map" do
  #   assert { Foo.new.collect.to_a == [:a, :b, :c] }
  # end
  #
  # test "detect, find" do
  #   assert { Foo.new.detect { |e| e == :b } == :b }
  #   assert { Foo.new.detect(-> { "xxx" }) { |v| v == :x} == "xxx" } # call が呼べないといけない。この機能は使いづらいせいか知られてない ★
  # end
  #
  # test "each.with_index" do
  #   assert { Foo.new.each.with_index.to_a == [[:a, 0], [:b, 1], [:c, 2]] }
  # end
  #
  # test "entries, to_a" do
  #   assert { Foo.new.to_a == [:a, :b, :c] }
  #   assert { Foo.new.entries == [:a, :b, :c] }
  # end
  #
  # test "select, find_all" do
  #   assert { Foo.new.select { |e| e >= :b } == [:b, :c] }
  # end
  #
  # test "reject" do
  #   assert { Foo.new.reject { |v| v >= :b } == [:a] }
  # end
  #
  # test "grep" do
  #   assert { Foo.new.grep(:a..:b) == [:a, :b] }
  # end
  #
  # test "include?, member?" do
  #   assert { Foo.new.include?(:a) == true }
  # end
  #
  # test "max, min" do
  #   assert { Foo.new.max == :c }
  #   assert { Foo.new.min == :a }
  # end
  #
  # test "sort" do
  #   assert { Foo.new.sort == [:a, :b, :c] }
  # end

  test "all?" do
    assert { [].all? == true }
    assert { [:a, :b].all? == true }
    assert { [:a, :a].all?(:a) == true }
    assert { [:a, :aa].all?(/a/) == true }
    assert { [0, 2].all?(&:even?) == true }
  end

  test "any?" do
    assert { [].any? == false }
    assert { [:aa, nil].any? == true }
    assert { [:aa, nil].any?(/a/) == true }
    assert { [0, 1].any?(&:even?) == true }
  end

  test "none?" do
    assert { [].none? == true }
    assert { [false].none? == true }
    assert { [1, 3].none?(&:even?) == true }
    assert { [:a].none?(/b/) == true }
  end

  test "one?" do
    assert { [].one? == false }
    assert { [1].one? == true }
    assert { [0, 1, 2].one?(&:even?) == false }
    assert { [0, 1, 2].one?(&:odd?) == true }
    assert { [:a, :a, :b].one?(/a/) == false }
  end

  test "chunk" do
    assert { [:a, :b, :b, :a].chunk(&:itself).to_a == [[:a, [:a]], [:b, [:b, :b]], [:a, [:a]]] }
    assert { [0, 1, 1, 0].chunk(&:even?).to_a == [[true, [0]], [false, [1, 1]], [true, [0]]] }
    assert { [0, 1, "2", 3, 4].chunk { |e| (e.kind_of?(Integer) && e.even?) ? true : :_separator }.to_a == [[true, [0]], [true, [4]]] }
    assert { [0, 1, "2", 3, 4].chunk { |e| (e.kind_of?(Integer) && e.even?) ? true : :_alone }.to_a == [[true, [0]], [:_alone, [1]], [:_alone, ["2"]], [:_alone, [3]], [true, [4]]] }

    # ★ 引数を省略したら itself を指定したことにしてほしい
    assert { [:a].chunk.to_a == [] }
  end

  test "chunk_while" do
  end

  test "collect, map" do
    assert { [:a, :b].collect(&:to_s) == ["a", "b"] }
  end

  test "collect_concat, flat_map" do
    assert { [[:a, :b], [:c, :d]].collect_concat(&:itself) == [:a, :b, :c, :d] }

    # 結果を flatten しているわけではなく1段のみネストを浅くしている
    assert { [[[:a, :b]], [[:c, :d]]].collect_concat(&:itself) == [[:a, :b], [:c, :d]] }

    # ★ もし要素の一つが配列ではない場合 collect を呼んだのと同じになる (が、将来、警告やエラーになる可能性はありそう)
    assert { [[:a, :b], [:c, :d]].collect_concat(&:join) == ["ab", "cd"] }
    assert { [[:a, :b], [:c, :d]].collect(&:join) == ["ab", "cd"] }
  end

  test "count" do
    assert { [:a, :b].count == 2 }
    assert { [:a, :b].count(:a) == 1 }
    assert { [2, 3, 4].count(&:odd?) == 1 }

    # ★ === ではなく == の比較なのでマッチしていない
    assert { [:a, :b].count(/a/) == 0 }
  end

  test "cycle" do
    assert { [].cycle {} == nil }

    # ★ 引数に回数が指定できる
    assert { [:a, :b, :c].cycle(2).to_a == [:a, :b, :c, :a, :b, :c] }

    # 通し番号が欲しいときの例
    assert { [:a, :b, :c].cycle(2).with_index.to_a == [[:a, 0], [:b, 1], [:c, 2], [:a, 3], [:b, 4], [:c, 5]] }
  end

  test "detect, find" do
  end

  test "drop" do
  end

  test "drop_while" do
  end

  test "each_cons" do
  end

  test "each_entry" do
  end

  test "each_slice" do
  end

  test "each_with_index" do
  end

  test "each_with_object" do
  end

  test "entries, to_a" do
  end

  test "find_all, select" do
  end

  test "find_index" do
    assert { [].find_index(:a) == nil }
    assert { [:a, :b].find_index(:a) == 0 }
    assert { [:a, :b].find_index(&:itself) == 0 }
  end

  test "first" do
    assert { [:a, :b].first == :a }
    assert { [:a, :b].first(0) == [] }
    assert { [:a, :b].first(1) == [:a] }
    assert { [:a, :b].first(2) == [:a, :b] }
    assert { [:a, :b].first(3) == [:a, :b] }
    assert_raise(ArgumentError) { [:a, :b, :c].first(-1) }
  end

  test "last" do
    # ★ last はない。これは Array のメソッド
    assert_raise(NoMethodError) { [].each.last }
  end

  test "grep, grep_v" do
    # Enumerable ではなくそのまま配列を返す
    assert { [:a, :b, :c].grep(/b/) == [:b] }
    assert { [:a, :b, :c].grep_v(/b/) == [:a, :c] }

    # ブロック
    a = []
    [:a, :b, :c].grep(/b/) { |e| a << e }
    assert { a == [:b] }
  end

  test "group_by" do
    assert { [0, 1, 2, 3].group_by(&:even?) == {true => [0, 2], false => [1, 3]} }
  end

  test "include?, member?" do
    assert { [:a].member?(:a) == true }
  end

  test "inject, reduce" do
  end

  test "lazy" do
  end

  test "max" do
  end

  test "max_by" do
  end

  test "min" do
  end

  test "min_by" do
  end

  test "minmax" do
  end

  test "minmax_by" do
  end

  test "partition" do
  end

  test "reject" do
  end

  test "reverse_each" do
  end

  test "slice_after" do
  end

  test "slice_before" do
  end

  test "slice_when" do
  end

  test "sort" do
  end

  test "sort_by" do
  end

  test "sum" do
  end

  test "take" do
  end

  test "take_while" do
  end

  test "to_h" do
  end

  test "uniq" do
  end

  test "zip" do
    assert { [:a, :b].zip([1, 2]) == [[:a, 1], [:b, 2]] }
    assert { [:a, :b].zip([1, 2], [3, 4]) == [[:a, 1, 3], [:b, 2, 4]] }

    v = []
    [:a, :b].zip([1, 2]) { |e| v << e }
    assert { v == [[:a, 1], [:b, 2]] }
  end
end
