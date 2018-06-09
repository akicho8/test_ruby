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
      assert { JSON.create_id == "json_class" }
      JSON.create_id = "foo"
      assert { JSON.create_id == "foo" }
      JSON.create_id = before_value
    end

    test "generator" do
      assert { JSON.generator == JSON::Ext::Generator }
    end

    test "parser" do
      assert { JSON.parser.inspect == "JSON::Ext::Parser" }
    end

    test "state" do
      assert { JSON.state.inspect == "JSON::Ext::Generator::State" }
    end
  end
end
