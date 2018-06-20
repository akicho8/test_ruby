require "./test_helper"

# https://docs.ruby-lang.org/ja/2.5.0/class/MatchData.html
class TestMatchData < Test::Unit::TestCase
  test "==, eql?" do
    a = "foo".match(/o/)
    b = "foo".dup.match(/o/)
    assert { a == b }
  end

  test "[]" do
    md = "ab".match(/(?<x>.)(?<y>.)/)

    assert { md[-1] == "b" }
    assert { md[0] == "ab" }
    assert { md[1] == "a" }
    assert { md[2] == "b" }
    assert { md[3] == nil }

    assert { md[1..2] == ["a", "b"] }

    assert { md[1, 2] == ["a", "b"] }

    assert { md[:x] == "a" }
    assert { md["x"] == "a" }
  end

  test "begin, end" do
    md = "ab".match(/(?<x>.)(?<y>.)/)
    assert { md.begin(2) == 1 }
    assert { md.begin(:y) == 1 }

    assert { md.end(2) == 2 }
    assert { md.end(:y) == 2 }
  end

  test "captures" do
    assert { "ab".match(/(.)(.)/).captures == ["a", "b"] }
  end

  test "hash" do
    md = "ab".match(/(?<x>.)(?<y>.)/)
    assert { md.hash.kind_of?(Integer) == true }
  end

  test "inspect" do
    md = "ab".match(/(?<x>.)(?<y>.)/)
    assert { md.inspect == "#<MatchData \"ab\" x:\"a\" y:\"b\">" }
  end

  test "length, size" do
    md = "ab".match(/(?<x>.)(?<y>.)/)
    assert { md.length == 3 }
    assert { md.size == 3 }
  end

  test "named_captures" do
    md = "ab".match(/(?<x>.)(?<y>.)/)
    assert { md.named_captures == {"x"=>"a", "y"=>"b"} }
  end

  test "names" do
    md = "ab".match(/(?<x>.)(?<y>.)/)
    assert { md.names == ["x", "y"] }
  end

  test "offset" do
    md = "ab".match(/(?<x>.)(?<y>.)/)
    assert { md.offset(:x) == [0, 1] }
  end

  test "pre_match, post_match" do
    md = "abc".match(/b/)
    assert { md.pre_match == "a" }
    assert { md.post_match == "c" }
  end

  test "string, regexp" do
    md = "abc".match(/b/)
    assert { md.string == "abc" }
    assert { md.regexp == /b/ }
  end

  test "to_a" do
    md = "ab".match(/(?<x>.)(?<y>.)/)
    assert { md.to_a == ["ab", "a", "b"] }
  end

  test "to_s" do
    md = "abcd".match(/(?<x>.)(?<y>.)/)
    assert { md.to_s == "ab" }
  end

  test "values_at" do
    md = "ab".match(/(?<x>.)(?<y>.)/)
    assert { md.values_at(:x, :y) == ["a", "b"] }
  end
end
