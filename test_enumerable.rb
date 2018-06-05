require "./test_helper"

class TestEnumerable < Test::Unit::TestCase
  class Foo
    include Enumerable
    def each(&block)
      [:a, :b, :c].each(&block)
    end
  end

  test "collect, map" do
    assert { Foo.new.collect.to_a == [:a, :b, :c] }
  end

  test "detect, find" do
    assert { Foo.new.detect { |e| e == :b } == :b }
    assert { Foo.new.detect(-> { "xxx" }) { |v| v == :x} == "xxx" } # call が呼べないといけない。この機能は使いづらいせいか知られてない ★
  end

  test "each.with_index" do
    assert { Foo.new.each.with_index.to_a == [[:a, 0], [:b, 1], [:c, 2]] }
  end

  test "entries, to_a" do
    assert { Foo.new.to_a == [:a, :b, :c] }
    assert { Foo.new.entries == [:a, :b, :c] }
  end

  test "select, find_all" do
    assert { Foo.new.select { |e| e >= :b } == [:b, :c] }
  end

  test "reject" do
    assert { Foo.new.reject { |v| v >= :b } == [:a] }
  end

  test "grep" do
    assert { Foo.new.grep(:a..:b) == [:a, :b] }
  end

  test "include?, member?" do
    assert { Foo.new.include?(:a) == true }
  end

  test "max, min" do
    assert { Foo.new.max == :c }
    assert { Foo.new.min == :a }
  end

  test "sort" do
    assert { Foo.new.sort == [:a, :b, :c] }
  end
end
# >> Loaded suite -
# >> Started
# >> ..........
# >> Finished in 0.005476 seconds.
# >> -------------------------------------------------------------------------------
# >> 10 tests, 13 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 1826.15 tests/s, 2374.00 assertions/s
