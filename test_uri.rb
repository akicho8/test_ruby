require "./test_helper"
require "uri"

# https://docs.ruby-lang.org/ja/latest/library/uri.html
class TestUri < Test::Unit::TestCase
  test ".decode_www_form, .encode_www_form" do
    assert { URI.decode_www_form("a=1&a=2") == [["a", "1"], ["a", "2"]] }
    assert { URI.encode_www_form({a: 1, b: 2}) == "a=1&b=2" }
  end

  # よくわからん
  test ".decode_www_form_component, .encode_www_form_component" do
    assert { URI.decode_www_form_component("%41") == "A" }
    assert { URI.encode_www_form_component("A") == "A" }
  end

  test ".escape, .encode" do
    assert { URI.escape("http://example.net/?q=あ") == "http://example.net/?q=%E3%81%82" }
    assert { URI.encode("http://example.net/?q=あ") == "http://example.net/?q=%E3%81%82" }
  end

  test ".extract" do
    assert { URI.extract("xxx http://example.net/ xxx") == ["http://example.net/"] }
  end

  test ".join" do
    # こんな場合 foo が消えるので注意
    assert { URI.join("http://example.net/foo", "/bar").to_s == "http://example.net/bar" }
  end

  # 配列で欲しいときは split もある
  test ".parse" do
    e = URI.parse("http://example.net/foo/bar.rb?foo=1&bar=2")
    assert { e.component == [:scheme, :userinfo, :host, :port, :path, :query, :fragment] }
    assert { e.scheme == "http" }
    assert { e.userinfo == nil }
    assert { e.host == "example.net" }
    assert { e.port == 80 }
    assert { e.path == "/foo/bar.rb" }
    assert { e.query == "foo=1&bar=2" }
    assert { e.fragment == nil }
  end

  # 基本は parse 使った方がよさそう
  test ".split" do
    assert { URI.split("http://example.net/foo/bar.rb?foo=1&bar=2") == ["http", nil, "example.net", nil, nil, "/foo/bar.rb", nil, "foo=1&bar=2", nil] }
  end

  test ".regexp" do
    assert { URI.regexp(["mailto"]).to_s == "(?x-mi:(?=(?-mix:mailto):)\n        ([a-zA-Z][\\-+.a-zA-Z\\d]*):                           (?# 1: scheme)\n        (?:\n           ((?:[\\-_.!~*'()a-zA-Z\\d;?:@&=+$,]|%[a-fA-F\\d]{2})(?:[\\-_.!~*'()a-zA-Z\\d;\\/?:@&=+$,\\[\\]]|%[a-fA-F\\d]{2})*)                    (?# 2: opaque)\n        |\n           (?:(?:\n             \\/\\/(?:\n                 (?:(?:((?:[\\-_.!~*'()a-zA-Z\\d;:&=+$,]|%[a-fA-F\\d]{2})*)@)?        (?# 3: userinfo)\n                   (?:((?:(?:[a-zA-Z0-9\\-.]|%\\h\\h)+|\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}|\\[(?:(?:[a-fA-F\\d]{1,4}:)*(?:[a-fA-F\\d]{1,4}|\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})|(?:(?:[a-fA-F\\d]{1,4}:)*[a-fA-F\\d]{1,4})?::(?:(?:[a-fA-F\\d]{1,4}:)*(?:[a-fA-F\\d]{1,4}|\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}))?)\\]))(?::(\\d*))?))? (?# 4: host, 5: port)\n               |\n                 ((?:[\\-_.!~*'()a-zA-Z\\d$,;:@&=+]|%[a-fA-F\\d]{2})+)                 (?# 6: registry)\n               )\n             |\n             (?!\\/\\/))                           (?# XXX: '\\/\\/' is the mark for hostport)\n             (\\/(?:[\\-_.!~*'()a-zA-Z\\d:@&=+$,]|%[a-fA-F\\d]{2})*(?:;(?:[\\-_.!~*'()a-zA-Z\\d:@&=+$,]|%[a-fA-F\\d]{2})*)*(?:\\/(?:[\\-_.!~*'()a-zA-Z\\d:@&=+$,]|%[a-fA-F\\d]{2})*(?:;(?:[\\-_.!~*'()a-zA-Z\\d:@&=+$,]|%[a-fA-F\\d]{2})*)*)*)?                    (?# 7: path)\n           )(?:\\?((?:[\\-_.!~*'()a-zA-Z\\d;\\/?:@&=+$,\\[\\]]|%[a-fA-F\\d]{2})*))?                 (?# 8: query)\n        )\n        (?:\\#((?:[\\-_.!~*'()a-zA-Z\\d;\\/?:@&=+$,\\[\\]]|%[a-fA-F\\d]{2})*))?                  (?# 9: fragment)\n      )" }
  end

  # URIとして無効な正規表現。これは便利
  test "UNSAFE" do
    assert { URI::UNSAFE.to_s == "(?-mix:[^\\-_.!~*'()a-zA-Z\\d;\\/?:@&=+$,\\[\\]])" }
  end
end
