require "./test_helper"

# https://docs.ruby-lang.org/ja/latest/class/Comparable.html
class TestComparable < Test::Unit::TestCase
  class C
    include Comparable

    attr_reader :x

    def initialize(x)
      @x = x
    end

    # これを定義することで Comparable で < <= == >= > betwween? clamp? が使えるようになる
    def <=>(other)
      @x <=> other.x
    end
  end

  test "(operator)" do
    assert { C.new(1) <  C.new(2) }
    assert { C.new(2) <= C.new(2) }
    assert { C.new(2) == C.new(2) }
    assert { C.new(2) >= C.new(2) }
    assert { C.new(2)  > C.new(1) }
  end

  test "#between?" do
    assert { C.new(1).between?(C.new(0), C.new(2)) }
    assert { !C.new(-1).between?(C.new(0), C.new(2)) }
  end

  test "#clamp" do
    v = C.new(1)
    a = C.new(10)
    b = C.new(20)
    r = v.clamp(a, b)
    assert { r.object_id == a.object_id } # v が補正されて更新されたのではなく a が返っている
  end

  # これは Comparable の機能ではないけど <=> があれば使える
  test "#sort" do
    assert { [C.new(1), C.new(2)] == [C.new(2), C.new(1)].sort }
  end
end
# >> Loaded suite -
# >> Started
# >> ....
# >> Finished in 0.004281 seconds.
# >> -------------------------------------------------------------------------------
# >> 4 tests, 9 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 934.36 tests/s, 2102.31 assertions/s
