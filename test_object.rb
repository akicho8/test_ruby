require "./test_helper"

class TestObject < Test::Unit::TestCase
  test "new" do
    assert { Object.new }
  end
end
