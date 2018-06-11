require "./test_helper"

# https://docs.ruby-lang.org/ja/2.4.0/class/BasicObject.html
class TestBasicObject < Test::Unit::TestCase
  test "Object の親" do
    assert { Object.superclass == BasicObject }
  end

  sub_test_case "InstanceMethods" do
    test "!" do
      assert { BasicObject.new.! == false }
    end

    test "!=, ==" do
      assert { BasicObject.new != "x" }
      assert { !(BasicObject.new == "x") }
    end

    test "__id__" do
      assert { BasicObject.new.__id__ }
    end

    test "__send__" do
      assert { BasicObject.new.__send__(:__id__) }
    end

    test "equal?" do
      assert { BasicObject.new.equal?("x") == false }
    end

    test "instance_eval" do
      assert { BasicObject.new.instance_eval { __id__ } }
    end

    test "instance_exec" do
      assert { BasicObject.new.instance_exec(1, &:itself) == 1 }
    end
  end

  sub_test_case "PrivateMethods" do
    test "method_missing" do
      c = Class.new do
        def method_missing(name, *args)
          [name, args]
        end
      end
      assert { c.new.foo(1, 2) == [:foo, [1, 2]] }
    end

    test "singleton_method_added" do
      o = Class.new {
        attr_accessor :v
        def singleton_method_added(name)
          @v = name
        end
      }.new

      def o.foo
      end

      assert { o.v == :foo }
    end

    test "singleton_method_removed" do
      o = Class.new {
        attr_accessor :v
        def singleton_method_removed(name)
          @v = name
        end
      }.new
      def o.foo
      end
      class << o
        remove_method :foo
      end
      assert { o.v == :foo }
    end

    test "singleton_method_undefined" do
      o = Class.new {
        attr_accessor :v
        def initialize
          @v = []
        end
        def singleton_method_undefined(name)
          @v << name
        end
      }.new
      def o.foo
      end
      def o.bar
      end
      class << o
        undef_method :foo
      end
      o.instance_eval { undef bar }
      assert { o.v == [:foo, :bar] }
    end
  end
end
