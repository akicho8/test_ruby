require "./test_helper"

class TestDidYouMean < Test::Unit::TestCase
  test "秘密の機能" do
    # initialize のスペル間違いを指摘してくれる
    require "did_you_mean/experimental"
    Class.new do
      def iitialize # warning: iitialize might be misspelled, perhaps you meant initialize?
      end
    end
  end
end
# >> Loaded suite -
# >> Started
# >> .
# >> Finished in 0.005025 seconds.
# >> -------------------------------------------------------------------------------
# >> 1 tests, 0 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 199.00 tests/s, 0.00 assertions/s
