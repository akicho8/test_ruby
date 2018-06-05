
# Thread-stamp: <02/10/22 16:20:01 ikeda>

require "./test_helper"

class TestThread < Test::Unit::TestCase
  setup do

    # メインスレッドのみになるまで待つ
    while Thread.list.size != 1
    end

    fail if Thread.list.size != 1 # メインスレッドのみの状態になっている事を確認
  end
  teardown do
    setup
  end
  test "s_abort_on_exception" do
    assert_equal(false, Thread.abort_on_exception)

    # falseの場合は例外時に終了しないので捕獲出来る
    Thread.abort_on_exception = false
    begin
      Thread.start {raise}.join
    rescue
    end

    # trueの場合は例外時に終了するで捕獲出来ない
    # でもこれだとテスト出来ないのでコメントアウト
#     Thread.abort_on_exception = true
#     begin
#       Thread.start {raise}.join
#     rescue
#     end

    Thread.abort_on_exception = false
  end
  test "s_critical" do
    t = Thread.new {
      count = 0
      begin
	loop {
	  Thread.critical = count.between?(0, 10) # カウンタが0〜10の間は例外に対応しない
	  sleep(0.01)
	  count += 1
	}
      rescue
      end
      count
    }
    sleep(0.1)
    t.raise("")
    assert_equal(true, 10 < t.value)
  end
  test "s_current" do
    assert_equal("run", Thread.current.status)
  end
  test "s_exit" do
    t = Thread.start{Thread.exit;1}.join
    assert(t.value != 1)
  end
  test "s_fork" do		# new, start
    assert_equal(1, Thread.new  {1}.join.value)
    assert_equal(1, Thread.start{1}.join.value)
    assert_equal(1, Thread.fork {1}.join.value)
    # 引数を渡す
    assert_equal(1, Thread.fork(1) {|i|i}.join.value)
  end
  test "s_kill" do
    x = Thread.new{sleep(1)}
    assert_equal(true, x.alive?)
    Thread.kill(x)
    assert_equal(false, x.alive?)
  end
  test "s_list" do
    # 3つのスレッドを生成して数を数えるとメインスレッドを含むの4になるテスト
    x = (0...3).collect{|i|Thread.new{sleep(1)}}
    assert_equal(4, Thread.list.size)
    # 生成したスレッドを削除すると 1 になる
    x.each {|e| Thread.kill(e)}
    assert_equal(1, Thread.list.size)
  end
  test "s_main" do
    # 生成したスレッド内でもメインスレッドは１つ
    assert_equal(true, Thread.new{Thread.main}.join.value == Thread.main)

    # メインスレッド内でのカレントスレッドはメインスレッドと同じであある確認
    assert_equal(true, Thread.main == Thread.current)
  end
  test "s_pass" do
    # スレッドの処理を一回だけしか行わずすぐに切替える方法
    c = 0
    x = Thread.start{loop{Thread.pass; c += 1}}
    while c < 5; end
    Thread.kill(x)
    assert_equal(5, c)
  end
  test "s_start" do		# newとほぼ同じだがサブクラス化した時 initialize が呼ばれない
    x = Class.new(Thread)
    x.class_eval("def initialize(*arg, &block); super('B', &block); end")
    assert_equal("B",   x.new("A"){|e|e}.join.value) # サブクラスの initialize が反映されている
    assert_equal("A", x.start("A"){|e|e}.join.value) # サブクラスの initialize が反映されていない
  end
  test "s_stop" do
    # 起動して直に sleep モードになるスレッド起動
    x = Thread.new{Thread.stop; 1}
    assert_equal(true, x.stop?)
    assert_equal("sleep", x.status)
    # 起こして正常終了するか調べる
    x.wakeup
    x.join
    assert_equal(1, x.value)
  end
  test "AREF_ASET_key?" do
    x = Thread.new{}.join
    x[:A] = 1
    x["A"] = 2
    assert_equal(true,  x[:A] == x["A"])
    assert_equal(true,  x.key?(:A))
    assert_equal(false, x.key?(:B))
  end
  test "AREF_ASET_error" do
    x = Thread.new{
      x[:var] = 1 # ここでエラーが発生しているがメインスレッドはデフォルトでは中断されない
    }
    # 一見正しく動作するように見えるが x は初期化されていないのでエラーになる

    if RUBY_VERSION < "1.8"
      assert_raises(NameError) {x.join} # エラーは join した時に再発生する
    else
      assert_raises(NoMethodError) {x.join} # エラーは join した時に再発生する
    end
  end
  test "AREF_ASET_ok" do
    # 正しく動作させる方法
    x = Thread.new{
      Thread.current[:var] = 1
    }
    x.join
    assert_equal(1, x[:var])
  end

  test "abort_on_exception" do
    # raiseで例外しても終了しないけど、joinするとエラーが再発生する
    x = Thread.new{x.abort_on_exception=false; raise} # これはまずいかも2002-11-16(Sat)
    # assert_raises(RuntimeError, x.join) # 捕獲失敗

#     # raiseで例外すると終了する(テストすると終了してしまうのでコメントアウト)
#     x = Thread.new{sleep(0.01); raise}
#     x.abort_on_exception = true
  end
  test "alive?" do
    assert_equal(true, Thread.current.alive?) # "run" or "sleep"
  end
  test "exit" do			# kill
    x = Thread.new{Thread.stop}
    x.exit # or x.kill
    assert_equal(false, x.alive?)
  end
  test "join" do
    c = 0
    x = Thread.new{5.times{Thread.pass; c+=1}}
    assert(c != 5)		# この時点でスレッドはまだ動作中なので5になってない
    x.join			# 終了するまで待つ（join=合流の意)
    assert(c == 5)
  end
  test "raise" do
    # x.abort_on_exception = true としておくとプログラムが終了する
    assert_equal(1, Thread.list.size)
    x = Thread.new{Thread.stop}
    x.raise("foo")			# スレッドの外からでもraiseは可能で必ず引数が必要
    # sleep(0.01)
    assert_equal(1, Thread.list.size)   # raiseするとスレッドはいなくなるらしい
  end
  test "priority" do
    x = Thread.new{}
    assert_equal(0, x.priority)
    x.priority = 1
    assert_equal(1, x.priority)
    assert_equal(0, Thread.main.priority)
  end
  test "safe_level" do
    x = Thread.new{}
    assert_equal(0, x.safe_level)
    assert_equal(0, Thread.main.safe_level)
  end
  test "stop?" do
    x = Thread.new{Thread.stop}
    assert_equal(true, x.stop?)
    x.wakeup
    x.join
    assert_equal(false, x.alive?)
  end
  test "wakeup" do
    x = Thread.new{Thread.stop}
    assert_equal(true, x.stop?)
    x.wakeup
    x.join
    assert_equal(false, x.alive?)
  end
  test "run" do
    x = Thread.new{Thread.stop}
    assert_equal(true, x.stop?)
    x.run			# (Thread.wakeup; Thread.pass) と同じ意味
    x.join
    assert_equal(false, x.alive?)
    assert_equal(0, 0)
  end
  test "value" do
    assert_equal(1, Thread.new{1}.join.value)
  end
  test "status" do
    assert_equal(0, 0)
  end

  # 指定したループを0.1秒間実行するサンプル
  test "sample_1" do
    t = Thread.new{sleep(0.1)}
    count = 0
    loop {
      break unless t.alive?
      # 0.1間の間、実行する処理
      count += 1
    }
    assert(count >= 1)
  end
end
