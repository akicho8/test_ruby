require "./test_helper"

require "timeout"

class TestTimeout < Test::Unit::TestCase
  test "basic" do
    r = ""
    begin
      r = timeout(0.1) {sleep(0.2)}
    rescue TimeoutError
      r = "Error"
    end
    assert_equal("Error", r)
  end
end
