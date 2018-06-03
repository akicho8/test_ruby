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
      SecureRandom.base64       # => "/lX60EoNWPLA3bYB34WmNw=="
      assert_equal(24, SecureRandom.base64(16).size) # 16 * 3 / 2 (マニュアルには約4/3とあるが3/2になるっぽい)
    end

    test "hex" do
      SecureRandom.hex       # => "9abb98875f3b275ec6ff5a0e6cc3c50e"
      assert_equal(8, SecureRandom.hex(8 / 2).size) # 8文字欲しかったらその半分を指定する
    end

    test "random_bytes" do
      SecureRandom.random_bytes # => "67\xDE\xAE\x17!\xEA=\vZ\x15\x127$\xA4\x02"
      assert SecureRandom.random_bytes(16).unpack("C*") # 16.times.collect { rand(256) } と書くより速いかも★
    end

    # rand の仕様と同じっぽい
    test "random_number" do
      SecureRandom.random_number # => 0.7933968690369307
      assert SecureRandom.random_number(1..5) # ドキュメントにはないが Range もいける
    end

    test "urlsafe_base64" do
      SecureRandom.urlsafe_base64            # => "F3Vi_MadONupAWbdyd1Gzg"
      SecureRandom.urlsafe_base64(nil, true) # => "RUvxMgnWlySEhZChmu2-UA=="
      assert SecureRandom.urlsafe_base64
    end

    test "uuid" do
      SecureRandom.uuid  # => "ec6c065e-7c8c-4a6a-82a0-3c4f28eea6ef"
      assert SecureRandom.uuid
    end
  end
end
# >> Loaded suite -
# >> Started
# >> ........
# >> Finished in 0.001505 seconds.
# >> -------------------------------------------------------------------------------
# >> 8 tests, 8 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 5315.61 tests/s, 5315.61 assertions/s
