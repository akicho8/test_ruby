require "./test_helper"

require "socket"

class TestIPSocket < Test::Unit::TestCase
  test "superclass" do
    assert { IPSocket.superclass == BasicSocket }
  end

  test "s_getaddress" do
    assert { IPSocket.getaddress('localhost') == "127.0.0.1" }
  end

  test "addr" do
    x = UDPSocket.new
    x.bind('localhost', 8765)
    BasicSocket.do_not_reverse_lookup = false # ホスト名参照する
    assert { x.addr == ["AF_INET", 8765, "127.0.0.1", "127.0.0.1"] }
    BasicSocket.do_not_reverse_lookup = true # ホスト名参照しない
    assert { x.addr == ["AF_INET", 8765, "127.0.0.1", "127.0.0.1"] }
  ensure
    BasicSocket.do_not_reverse_lookup = false
  end
end
# >> Loaded suite -
# >> Started
# >> ...
# >> Finished in 0.019724 seconds.
# >> -------------------------------------------------------------------------------
# >> 3 tests, 4 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 152.10 tests/s, 202.80 assertions/s
