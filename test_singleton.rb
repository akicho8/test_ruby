


require "./test_helper"

require "singleton"

class SingletonTest
  include Singleton
  attr_reader :count
  def initialize # Singletonの場合 initialize に引数は書くことが出来ない
    @count = 0
  end
  def up
    @count += 1
  end
end

class TestSingleton < Test::Unit::TestCase
  # newは出来なくなる(ということは initialize も出来ない)
  test "new_NameError" do
    assert_raises(NameError){SingletonTest.new} if RUBY_VERSION <= "1.6"
    assert_raises(NoMethodError){SingletonTest.new} if RUBY_VERSION >= "1.8"
  end

  # インスタンスが共有されている証明
  # これを利用するとグローバル変数一切使わないコーディングが可能
  test "instance" do
    x = SingletonTest.instance
    y = SingletonTest.instance
    assert_equal(x.object_id, y.object_id)
    x.up
    y.up
    assert_equal(2, x.count)
    assert_equal(2, y.count)
  end
end
