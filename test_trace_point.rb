require "./test_helper"

class TestTracePoint < Test::Unit::TestCase
  # 基本的な使い方
  test "trace" do
    trace = TracePoint.trace(:line) { |tp| } # new して enable と同じ
    trace.disable               # これで止めないと大変なことになる
  end

  test "ブロック引数と戻値は同じ" do
    v = nil
    trace = TracePoint.trace(:line) { |tp| v = tp }
    Math.sin(0)
    trace.disable
    assert { trace == v }
  end

  # いきなり有効化したくない場合
  test "new" do
    trace = TracePoint.new(:line) do |tp|
      # p tp
    end

    trace.enable
    # ここだけ有効
    trace.disable

    trace.enable do
      # ここだけ有効。これは便利
      trace.disable do
        # ここだけ無効
      end
    end

    assert { trace.enabled? == false }
  end

  test "tp.self と tp.binding.eval('self') は同じ" do
    v1 = nil
    v2 = nil
    trace = TracePoint.new(:line) { |tp| v1 = tp.binding.eval('self') }
    trace.enable { v2 = self; 1 }
    assert { v1 == v2 }
  end
end
# >> Loaded suite -
# >> Started
# >> ....
# >> Finished in 0.008612 seconds.
# >> -------------------------------------------------------------------------------
# >> 4 tests, 3 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 464.47 tests/s, 348.35 assertions/s
