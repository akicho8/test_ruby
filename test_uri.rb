


require "./test_helper"

require "uri"

class TestURI < Test::Unit::TestCase
  def uri_info(uri)
    puts uri
    u = URI.parse(uri)
    u.component.each{|e|
      puts "#{e.to_s.ljust(8)} => #{u.send(e).inspect}"
    }
  end
  test "view" do
    uri_info("http://www.google.net")
  end
  test "basic" do
    s = "http://www.google.co.jp/secret/index.rb?foo=1&bar=2"
    x = URI.parse(s)
    assert_equal([:scheme, :userinfo, :host, :port, :path, :query, :fragment], x.component)
    assert_equal("http", x.scheme)
    assert_equal(nil, x.userinfo)
    assert_equal("www.google.co.jp", x.host)
    assert_equal(80, x.port)
    assert_equal("/secret/index.rb", x.path)
    assert_equal("foo=1&bar=2", x.query)
    assert_equal(nil, x.fragment)
  end
end
