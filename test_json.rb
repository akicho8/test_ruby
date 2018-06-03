require "./test_helper"
require "json"

# https://docs.ruby-lang.org/ja/2.4.0/class/JSON.html
class TestJson < Test::Unit::TestCase
  sub_test_case "class_methods" do
    test "self[object, options] -> object" do
    end

    # これはなんだ？？？
    test "create_id" do
      before_value = JSON.create_id
      assert_equal("json_class", JSON.create_id)
      JSON.create_id = "foo"
      assert_equal("foo", JSON.create_id)
      JSON.create_id = before_value
    end

    test "generator" do
      assert_kind_of(Module, JSON.generator)
      assert_equal("JSON::Ext::Generator", JSON.generator.inspect)
    end

    test "parser" do
      assert_kind_of(Class, JSON.parser)
      assert_equal("JSON::Ext::Parser", JSON.parser.inspect)
    end

    test "state" do
      assert_kind_of(Class, JSON.state)
      assert_equal("JSON::Ext::Generator::State", JSON.state.inspect)
    end
  end
end
# >> Loaded suite -
# >> Started
# >> .....
# >> Finished in 0.001039 seconds.
# >> -------------------------------------------------------------------------------
# >> 5 tests, 8 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 4812.32 tests/s, 7699.71 assertions/s
