require "./test_helper"
require "base64"

class TestBase64 < Test::Unit::TestCase
  test "encode64, decode64" do
    assert_equal("Zm9v\n", enc = Base64.encode64("foo"))
    assert_equal("foo", Base64.decode64(enc))
  end

  test "strict_encode64, strict_decode64" do
    assert_equal("Zm9v", enc = Base64.strict_encode64("foo"))
    assert_equal("foo", Base64.strict_decode64(enc))
  end

  test "urlsafe_encode64, urlsafe_decode64" do
    assert_equal("Zm9v", enc = Base64.urlsafe_encode64("foo"))
    assert_equal("foo", Base64.urlsafe_decode64(enc))
  end
end
# >> Loaded suite -
# >> Started
# >> ...
# >> Finished in 0.000546 seconds.
# >> -------------------------------------------------------------------------------
# >> 3 tests, 6 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 5494.51 tests/s, 10989.01 assertions/s
