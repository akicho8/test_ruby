


require "./test_helper"

require "thread"

# TestQueue#test_queue ["size", "pop", "enq", "num_waiting", "clear", "length", "push", "deq", "<<", "empty?", "shift", "dup", "eql?", "protected_methods", "==", "frozen?", "===", "respond_to?", "class", "kind_of?", "__send__", "nil?", "instance_eval", "public_methods", "untaint", "__id__", "display", "inspect", "taint", "hash", "=~", "private_methods", "to_a", "is_a?", "clone", "equal?", "singleton_methods", "freeze", "type", "instance_of?", "send", "methods", "method", "tainted?", "instance_variables", "id", "to_s", "extend"]

class TestQueue < Test::Unit::TestCase
  test "s_new" do
    x = Queue.new
    assert_equal(0, x.size)
  end
  test "push_pop" do		# push/<</enq, pop/shift/deq
    x = Queue.new
    assert_equal(nil, x.push(1))
    assert_equal(nil, x << 2)
    assert_equal(1, x.pop)
    assert_equal(2, x.pop)
    # スレッドの外で実行すると全部例外をはく
    assert_raises(ThreadError){x.pop(false)}
    assert_raises(ThreadError){x.pop(true)}
    assert_raises(ThreadError){x.pop}
  end
  test "pop_error" do		# データが無ければ例外にする方法
    x = Queue.new
    error = ""
    t = Thread.new{
      begin
	x.pop(true)		# ここで true を指定すると例外をはく
      rescue => error
      end
    }
    assert_equal("#<ThreadError: queue empty>", error.inspect)
    t.join
  end
  test "size" do			# length
    x = Queue.new
    x.push("A")
    x.push("B")
    assert_equal(2, x.size)
  end
  test "clear" do
    x = Queue.new
    assert_equal(true, x.empty?)
    x << 1
    assert_equal(false, x.empty?)
    x.clear
    assert_equal(true, x.empty?)
  end
  test "empty?" do
    x = Queue.new
    assert_equal(true, x.empty?)
  end
  test "num_waiting" do		# 待っているスレッドの個数
    x = Queue.new
    y = (0...10).map{Thread.new{x.pop}}
    # ここには sleep(0.1) とかいれた方がいいのかも
    assert_equal(10, x.num_waiting)
    10.times{|i|x<<i}
    y.each{|e|e.join}
    assert_equal(0, x.num_waiting)
  end
end
