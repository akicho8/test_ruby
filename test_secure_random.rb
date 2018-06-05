require "./test_helper"

require "securerandom"

# https://docs.ruby-lang.org/ja/2.4.0/class/SecureRandom.html
class TestSecureRandom < Test::Unit::TestCase
  test "/dev/urandom" do
    assert File.read("/dev/urandom", 16).unpack("L*") # いざというときはこれで★
  end

  test ".ancestors" do
    assert_equal([SecureRandom], SecureRandom.ancestors)
  end

  test ".base64" do
    SecureRandom.base64       # => "8lv8BscfWkfo4lVYkWDBtw=="
    assert_equal(24, SecureRandom.base64(16).size) # 16 * 3 / 2 (マニュアルには約4/3とあるが3/2になるっぽい)
  end

  test ".hex" do
    SecureRandom.hex       # => "b77d3527cf8b283578ae07f90e8c66d2"
    assert_equal(8, SecureRandom.hex(8 / 2).size) # 8文字欲しかったらその半分を指定する
  end

  test ".random_bytes" do
    SecureRandom.random_bytes # => "09\xC1O_\xA6\xA4\xA4\xF6\xB5@H\x18k\xAA\x86"
    assert SecureRandom.random_bytes(16).unpack("C*") # 16.times.collect { rand(256) } と書くより速いかも★
  end

  # rand の仕様と同じっぽい
  test ".random_number" do
    SecureRandom.random_number # => 0.6144568418642011
    assert SecureRandom.random_number(1..5) # ドキュメントにはないが Range もいける
  end

  test ".urlsafe_base64" do
    SecureRandom.urlsafe_base64            # => "6GXvFivFD0WhkJInlJJCwA"
    SecureRandom.urlsafe_base64(nil, true) # => "pXhDHFosz1LCeLV8qofPow=="
    assert SecureRandom.urlsafe_base64
  end

  test ".uuid" do
    SecureRandom.uuid  # => "07b2c4cc-846b-418a-bdcb-434eb74f6a79"
    assert SecureRandom.uuid
  end
end
# >> Loaded suite -
# >> Started
# >> ........
# >> Finished in 0.001453 seconds.
# >> -------------------------------------------------------------------------------
# >> 8 tests, 8 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 5505.85 tests/s, 5505.85 assertions/s
