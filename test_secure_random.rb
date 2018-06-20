require "./test_helper"

require "securerandom"

# https://docs.ruby-lang.org/ja/2.4.0/class/SecureRandom.html
class TestSecureRandom < Test::Unit::TestCase
  test "/dev/urandom" do
    # ★ いざというときはこれで
    File.read("/dev/urandom", 16).unpack("L*") # => [1911262424, 1219990704, 2294222975, 1804001810]
  end

  test ".base64" do
    SecureRandom.base64       # => "OheFv6rBAavtl+XUCP23nA=="

    # マニュアルには約4/3とあるが3/2になるっぽい
    SecureRandom.base64(16).size # => 24
  end

  test ".hex" do
    SecureRandom.hex       # => "063a143c5c58684483597d1d7070ec4f"
    # 8文字欲しかったらその半分を指定する
    SecureRandom.hex(8 / 2).size # => 8
  end

  test ".random_bytes" do
    SecureRandom.random_bytes # => "\xE1\xEA\x9D\xD7sxk\xD1$\x9D4-\xBD\"g\xF3"
    # ★ 16.times.collect { rand(256) } と書くより速いかも
    SecureRandom.random_bytes(16).unpack("C*") # => [162, 184, 76, 49, 56, 211, 237, 113, 253, 67, 109, 114, 24, 243, 174, 180]
  end

  # rand の仕様と同じっぽい
  test ".random_number" do
    SecureRandom.random_number # => 0.7976781035403754
    # ★ドキュメントにはないが Range もいける
    SecureRandom.random_number(1..5) # => 2
  end

  test ".urlsafe_base64" do
    SecureRandom.urlsafe_base64            # => "kuaVrBy-nGmAR4boZggGmg"
    SecureRandom.urlsafe_base64(nil, true) # => "x_V8NLM660IjfVklVxQ6Ow=="
  end

  test ".uuid" do
    SecureRandom.uuid  # => "b2be5b2e-8bda-44cc-ac44-faae7885ead0"
  end
end
# >> Loaded suite -
# >> Started
# >> .......
# >> Finished in 0.001349 seconds.
# >> -------------------------------------------------------------------------------
# >> 7 tests, 0 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 5189.03 tests/s, 0.00 assertions/s
