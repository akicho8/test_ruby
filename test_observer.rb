


require "./test_helper"

require "observer"

class ObserverTestServer
  include Observable
  def initialize(div=1)
    @count = 0
    @div = div
  end
  def up			# 指定値の倍数の時だけ報告する
    @count += 1
    changed(true) if @count.modulo(@div) == 0
    notify_observers(@count)
  end
end

class ObserverTestDisplay
  attr_reader :state
  def initialize(obj=nil)
    obj.add_observer(self) if obj
    @state = nil
  end
  def update(count)
    @state = count
  end
end

class TestObserver < Test::Unit::TestCase

  # add_observer      - 追加
  # delete_observer   - 削除
  # delete_observers  - 削除(全て)
  # count_observers   - 追加した個数
  test "add_delete_obsrver" do
    # 元のオブジェクト生成。最初は監視するオブジェクトは0個
    x = ObserverTestServer.new
    assert_equal(0, x.count_observers)
    # 監視オブジェクトを3つ追加する
    a = ObserverTestDisplay.new
    b = ObserverTestDisplay.new
    c = ObserverTestDisplay.new
    x.add_observer(a)
    x.add_observer(b)
    x.add_observer(c)
    assert_equal(3, x.count_observers)
    # １つ削除
    x.delete_observer(a)
    assert_equal(2, x.count_observers)
    # 残り削除
    x.delete_observers
    assert_equal(0, x.count_observers)
  end

  # 通常一番シンプルな使い方
  test "notify_observer" do
    x = ObserverTestServer.new
    a = ObserverTestDisplay.new(x)
    x.up			# xのオブジェクトが変化したら
    assert_equal(1, a.state)	# aのオブジェクトに通知されている
    assert_equal(false, x.changed?) # 通知後は変化していない状態になる
  end

  # 毎回ではなく時々通知するテスト
  # カウンタが２の倍数時にのみ通知する
  test "changed" do
    x = ObserverTestServer.new(2)
    a = ObserverTestDisplay.new(x)
    x.up
    assert_equal(nil, a.state)	# 通知されていない
    x.up
    assert_equal(2, a.state)	# 通知された
  end
end
