


require "./test_helper"
require "stringio"

class TestStringIO < Test::Unit::TestCase
  setup do
  end
  teardown do
  end
  test "main" do
    f = StringIO.new
    f.print "A\n"
    f << "B\n"
    assert_equal("A\nB\n", f.string)
    assert_equal(2, f.string.split.size)
  end
end
