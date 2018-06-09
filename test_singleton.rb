require "./test_helper"

require "singleton"

class TestSingleton < Test::Unit::TestCase
  class Foo
    include Singleton

    attr_accessor :count

    # initialize に引数はかけない
    def initialize
      @count = 0
    end
  end

  test "インスタンスが共有されている" do
    a = Foo.instance
    b = Foo.instance
    assert { (a.object_id == b.object_id) == true }
  end
end
# >> Loaded suite -
# >> Started
# >> .
# >> Finished in 0.007107 seconds.
# >> -------------------------------------------------------------------------------
# >> 1 tests, 1 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 140.71 tests/s, 140.71 assertions/s
