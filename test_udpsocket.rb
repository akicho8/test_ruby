


require "./test_helper"

require "socket"

class TestUDPSocket < Test::Unit::TestCase
  test "superclass" do
    assert_equal(IPSocket, UDPSocket.superclass)
  end
  test "basic" do
    a = []
    t = Thread.start {
      s = UDPSocket.open
      s.bind(nil, 4321)
      2.times{a << s.recvfrom(256)}
    }
    # 1回目
    UDPSocket.open.send("foo", 0, 'localhost', 4321) # 非コネクション型
    # 2回目
    u = UDPSocket.open		# コネクション型
    u.connect('localhost', 4321)
    u.send("bar", 0)
    t.join
    assert_equal("foo", a[0][0])
    assert_equal("bar", a[1][0])
  end
end
