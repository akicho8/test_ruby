require "./test_helper"

require "ping"

class TestPing < Test::Unit::TestCase

  test "pingecho" do
    assert_equal(true, Ping::pingecho("www.google.co.jp", 1, 'http')) # 1秒間のタイムアウトで80ポートのチェック
  end

  # pingライブラリはポートの指定も可能なので
  # ポートスキャンもどきになる
  # localhost の場合に全てのポートで接続出来てしまうのはなぜだろう?
  # サーバーが生きているかどうかのチェックだからしょうがないのかも
  def port_scan(host, range, timeout=1)
    ports = []
    host ||= 'localhsot'
    tary = []
    range.each {|port|
      tary << Thread.new {
        ports << port if Ping::pingecho(host, timeout, port)
      }
    }
    tary.each{|e|e.join}
    ports.sort
  end

  test "port_scan" do
    assert_equal((79..81).to_a, port_scan("localhost", 79..81))
    assert_equal([80], port_scan("www.google.co.jp", 79..81))
  end

  test "website" do
    # microsoft.com は ping を返さない(1は1秒でタイムアウトの意味)
    assert_equal(false, Ping.pingecho("microsoft.com", 1))

    require "net/http"
    assert_equal(true, Net::HTTP.start("microsoft.com"){true})
  end
end
