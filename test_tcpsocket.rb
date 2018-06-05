


require "./test_helper"

require "socket"

class TestTCPSocket < Test::Unit::TestCase
  test "superclass" do
    assert_equal(IPSocket, TCPSocket.superclass)
  end
  test "s_gethostbyname" do
    assert_equal(["2ch.net", [], 2, "64.71.145.43"], TCPSocket.gethostbyname('www.2ch.net'))
    assert_equal(["localhost.localdomain", ["localhost"], 2, "127.0.0.1"], TCPSocket.gethostbyname('localhost'))
  end
  test "s_new" do
    x = TCPSocket.new('localhost', 'http')
    x.send("HEAD / HTTP/1.0\r\n\r\n", 0)
    assert_equal("HTTP/1.1 200 OK\r\n", x.gets)
  end
end
