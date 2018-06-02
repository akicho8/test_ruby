require "./test_helper"

require "securerandom"

# https://docs.ruby-lang.org/ja/2.4.0/class/SecureRandom.html
class TestSecureRandom < Test::Unit::TestCase
  test "/dev/urandom" do
    assert File.read("/dev/urandom", 16).unpack("L*") # いざというときはこれで★
  end

  sub_test_case "class_methods" do
    test "ancestors" do
      assert_equal([SecureRandom], SecureRandom.ancestors)
    end

    test "base64" do
      SecureRandom.base64       # => "pnO8+ayF+QlEOHmqnp6jaA=="
      assert_equal(24, SecureRandom.base64(16).size) # 16 * 3 / 2 (マニュアルには約4/3とあるが3/2になるっぽい)
    end

    test "hex" do
      SecureRandom.hex       # => "dc1dc633f79f8bbec2ab5adda7136b33"
      assert_equal(8, SecureRandom.hex(8 / 2).size) # 8文字欲しかったらその半分を指定する
    end

    test "random_bytes" do
      SecureRandom.random_bytes # => "\xBD;mCt\r\xB7\xE5\xA6\xCA\xD3\xE35.\xA9\x86"
      assert SecureRandom.random_bytes(16).unpack("C*") # 16.times.collect { rand(256) } と書くより速いかも★
    end

    # rand の仕様と同じっぽい
    test "random_number" do
      SecureRandom.random_number # => 0.3142176846774347
      assert SecureRandom.random_number(1..5) # ドキュメントにはないが Range もいける
    end

    test "urlsafe_base64" do
      SecureRandom.urlsafe_base64            # => "xdqInN00-GHZdqV2WiQq1Q"
      SecureRandom.urlsafe_base64(nil, true) # => "qaOovGRiJvS3zkmi7dfydQ=="
      assert SecureRandom.urlsafe_base64
    end

    test "uuid" do
      SecureRandom.uuid  # => "5f522b7e-6e43-4433-91d0-d4701b189c4b"
      assert SecureRandom.uuid
    end
  end
end
# >> Loaded suite -
# >> Started
# >> ........
# >> 
# >> Finished in 0.002155 seconds.
# >> ------
# >> 8 tests, 8 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> ------
# >> 3712.30 tests/s, 3712.30 assertions/s
