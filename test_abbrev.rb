require "./test_helper"
require "abbrev"

class TestAbbrev < Test::Unit::TestCase
  test "abbrev" do
    assert { ["foo", "bar"].abbrev == {"foo"=>"foo", "fo"=>"foo", "f"=>"foo", "bar"=>"bar", "ba"=>"bar", "b"=>"bar"} }
  end
end
