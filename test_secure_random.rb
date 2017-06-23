require "test/unit"

require "securerandom"

# https://docs.ruby-lang.org/ja/2.4.0/class/SecureRandom.html
class TestSecureRandom < Test::Unit::TestCase
  test "/dev/urandom" do
    assert File.read("/dev/urandom", 16).unpack("L*") # いざというときはこれで★
  end

  sub_test_case "class_methods" do
    test "base64" do
      SecureRandom.base64       # => "oAWAOk6kl/4INakQvzNzOA=="
      assert_equal(24, SecureRandom.base64(16).size) # 16 * 3 / 2 (マニュアルには約4/3とあるが3/2になるっぽい)
    end

    test "hex" do
      SecureRandom.hex       # => "3412601d44d1bb55d2da274afeed0c1a"
      assert_equal(8, SecureRandom.hex(8 / 2).size) # 8文字欲しかったらその半分を指定する
    end

    test "random_bytes" do
      SecureRandom.random_bytes # => "\"\x99\xFD\xF5\xB6\\R|\x81\x98<e\x7F2\xA6\xEC"
      assert SecureRandom.random_bytes(16).unpack("C*") # 16.times.collect { rand(256) } と書くより速いかも★
    end

    # rand の仕様と同じっぽい
    test "random_number" do
      SecureRandom.random_number # => 0.6078496615561456
      assert SecureRandom.random_number(1..5) # ドキュメントにはないが Range もいける
    end

    test "urlsafe_base64" do
      SecureRandom.urlsafe_base64            # => "Ap3iz7Sbrd2U6AfvoZibFg"
      SecureRandom.urlsafe_base64(nil, true) # => "j6cD97piWMjgbHJvT1HO5A=="
      assert SecureRandom.urlsafe_base64
    end

    test "uuid" do
      SecureRandom.uuid  # => "13753193-4c4e-47df-841b-bf7e53f7f30b"
      assert SecureRandom.uuid
    end
  end
end
# >> Loaded suite -
# >> Started
# >> .......
# >> 
# >> Finished in 0.002005 seconds.
# >> ------
# >> 7 tests, 7 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> ------
# >> 3491.27 tests/s, 3491.27 assertions/s
