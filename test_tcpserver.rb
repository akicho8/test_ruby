


require "../test_helper"

require "socket"

class TestTCPServer < Test::Unit::TestCase
  test "superclass" do
    assert_equal(TCPSocket, TCPServer.superclass)
  end
  test "basic" do
    gate = TCPServer.open(0) # サーバー起動(0なら自動割り当て)
    port = gate.addr[1]		# 割り当てられたポート取得
    t = Thread.start {
      s = gate.accept		# クラインアントがopenで接続するまで待つ
      gate.close
      v = s.gets		# 接続したソケットオブジェクト
      s.close
      v
    }
    x = TCPSocket.open('localhost', port) # クライアント起動
    x.print("Hello\n")		# サーバーはgetsで受け取るので必ず改行を含めて送る
    t.join			# サーバーのスレッドが終了のを待つ
    assert_equal("Hello\n", t.value)
  end
end
