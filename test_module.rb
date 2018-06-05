require "./test_helper"

# https://docs.ruby-lang.org/ja/latest/class/Module.html
class TestModule < Test::Unit::TestCase
  module MOD1
    BBB = 1
    AAA = 2
  end

  module M1
    module M2
      module M3
        module_function
        def nesting; Module.nesting; end
      end
    end
  end

  module X1
    include Math
  end

  class C1
    @@v1 = 1
    @@v2 = 2
    def initialize
      @@v3 = 3
    end
  end

  class XA
    def foo; end
  end
  class XB < XA
    def bar; end
  end

  module M4
    def foo; end
    module_function
    def bar; end
  end

  class C3
    private_class_method :new
    public_class_method :new
  end

  class C4
    @v = 1
  end

  class C5 < C4
    @v = 2
  end

  test ".constants" do         # 定数の取得
    assert { Module.constants.sort[0..2] == [:ARGF, :ARGV, :AVAILABLE_ORDERS] }
  end

  test ".nesting" do           # ネストの確認
    assert { Module.nesting == [TestModule] }
    assert { M1::M2::M3.nesting == [TestModule::M1::M2::M3, TestModule::M1::M2, TestModule::M1, TestModule] }
  end

  test ".new" do
    assert { Module.new }
  end

  test "compare" do
    assert_equal(true, Math > X1) # 「先祖の方が偉いから大きい」と覚える
    assert_equal(false, Math == X1)
    assert_equal(false, Math < X1)
    assert_equal(true, X1 == X1) # 自分と自分は等しい
  end

  test "compare2" do
    assert_equal(0, X1 <=> X1)  # 自分同士は0
    assert_equal(-1, X1 <=> Math) # X1がMathをインクルードしてれば-1
    assert_equal(+1, Math <=> X1) # MathをX1にインクルードしていれば+1
    # MathはX1にインクルードされている事を知らない。
    # という事は無関係な Singleton に変えても +1 になる
  end

  test "eqeqeq" do
    x = []
    assert_equal(true, Object === x) # xはObjectの子孫である
    assert_equal(false, Class === x) # xはClassの子孫ではない
    assert_equal(true, Module === Class) # ClassはModuleの子孫である
  end

  test "ancestors" do           # included_module は自分を含まない
    assert_equal([X1, Math], X1.ancestors) # X1にインクルードされているモジュールリスト(自分を含む)
  end

  test "class_variables" do
    # 最初の状態
    assert { C1.class_variables.sort == [:@@v1, :@@v2] }
    C1.new                      # instanceのなかで @@v3 が追加された
    assert { C1.class_variables.sort == [:@@v1, :@@v2, :@@v3] }
  end

  test "clone" do
    m = Math.clone
    assert(m != Math)           # 別のインスタンス
  end

  test "const_defined?" do
    assert { Math.const_defined?(:PI) == true }
  end

  test "const_get" do
    assert_equal(Math::PI, Math.const_get(:PI))
  end

  test "const_set" do
    Math.const_set("FOO", 123)
    assert { Math.const_get("FOO") == 123 }
    Math.module_eval { remove_const("FOO") }
  end

  test "constants" do
    assert { Math.constants == [:E, :DomainError, :PI] }
  end

  test "included_modules" do    # ancesterの場合は自分を含む
    assert_equal([Math], X1.included_modules) # X1にインクルードされているモジュールリスト(自分を含まない)
  end

  test "instance_methods" do
    assert { XA.instance_methods(false) == [:foo] }
    assert { XB.instance_methods(false) == [:bar] }
    assert_equal(true, XB.instance_methods(true).size > 2) # 引数trueをつけると先祖も全て返す
  end

  test "method_defined?" do
    # p Math.methods
    assert_equal(true,  M4.method_defined?(:foo)) # publicメソッドのみ？
    assert_equal(false,  M4.method_defined?(:bar)) # モジュールファンクションするとfalseになる
    assert_equal(false,  Math.method_defined?(:sin)) # これも同様
  end

  test "module_eval" do         # 全部こうやってテストした方がよかったかも？
    x = Module.new
    x.module_eval("def foo; end")
    assert { x.instance_methods(false) == [:foo] }
  end

  test "name" do
    assert { Module.new.name == nil }
    assert { Math.name == "Math" }
  end

  test "xxxxxx_instance_methods" do # public/private/protected
    x = Class.new
    x.class_eval { public;    def pub;end }
    x.class_eval { protected; def pro;end }
    x.class_eval { private;   def pri;end }

    assert { x.public_instance_methods(false) == [:pub] }
    assert { x.protected_instance_methods(false) == [:pro] }
    assert { x.private_instance_methods(false) == [:pri] }
  end

  test "xxxxxx_class_method" do # public/privateにする
    x = Class.new
    x.class_eval { private_class_method :new }
    x.class_eval { public_class_method :new }
    x.new

    if RUBY_VERSION >= "1.7.3"
      # 1.6.7 では x.new で失敗するとエラーになる
      x = Class.new
      x.class_eval { private_class_method :new }
      begin
        x.new
      rescue NameError
      end
      x.class_eval { public_class_method :new }
      x.new
    end
  end

  test "public_class_method" do
    x = Class.new
    x.class_eval { public;    def pub;end }
    x.class_eval { protected; def pro;end }
    x.class_eval { private;   def pri;end }
    assert { x.public_instance_methods(false) == [:pub] }
    assert { x.protected_instance_methods(false) == [:pro] }
    assert { x.private_instance_methods(false) == [:pri] }
  end

  test "alias_method" do
    x = Class.new
    x.class_eval {
      def foo; "A"; end
      alias_method :origFoo, :foo
      def foo; origFoo + "B"; end
    }
    assert_equal("AB", x.new.foo)
  end

  test "append_features" do
    if false
      return if RUBY_VERSION < "1.7.3"
      x = Class.new
      # p x.private_instance_methods(true)
      x.class_eval("append_features(Math)") if RUBY_VERSION < "1.8"
    end
  end

  # attr の第二引数を指定すると今は警告がでる
  test "attr, attr_reader, attr_writer" do
    m = Module.new do
      attr :a
      attr_reader :b
      attr_writer :c
    end
    assert { m.instance_methods(false).sort == [:a, :b, :c=] }
  end

  # extend する前に呼ばれて super しないといけない
  # 昔は super する必要なかった
  test "extend_object" do
    m = Module.new {
      def self.extend_object(o)
        if o == "a"
          super
        end
      end
      def foo
      end
    }
    assert { "a".extend(m).respond_to?(:foo) == true }
    assert { "b".extend(m).respond_to?(:foo) == false }
  end

  test "include" do
    m = Module.new
    a = Module.new
    b = Module.new
    m.module_eval { include a, b }
    assert { m.ancestors.include?(a) }
  end

  test "method_added" do
    x = Class.new
    x.module_eval("def self.method_added(id); @@x=id; end") # 登録されたメソッドのIDを保持
    x.module_eval("def foo; @@x; end") # メソッド登録(かつ@@xの参照)
    assert_equal("foo", x.new.foo.id2name)
  end

  test "module_function" do
    # module_function :foo とされているのをクラスにincludeした時、
    # privateになっている為に、public :foo している
    x = Module.new
    x.module_eval("def foo; 0; end")
    x.module_eval("module_function :foo") # ここで foo はコピーされている
    assert_equal(0, x.foo)      # コピーされたのを呼んでいる
    y = Class.new.class_eval{include x; public :foo}.new # ここにインクルードされたのはコピーじゃない
    assert_equal(0, y.foo)      # コピーされたのじゃないのを呼ぶ
    x.module_eval("def foo; 1; end") # 一番元を変更する
    assert_equal(1, y.foo)      # コピーされたのじゃないので結果が変った
    assert_equal(0, x.foo)      # コピーされたのを呼んでいるので変更無し
  end

  test "module_function2" do    # ここらへんはグダグダになってよくわからんようになった
    x = Module.new
    x.module_eval("module_function")
    x.module_eval("def foo; 0; end")
    #assert_equal(0, x.foo)
    y = Class.new.class_eval{include x}.new
    assert_equal(0, y.instance_eval{foo})
    x.module_eval("def foo; 1; end")
    assert_equal(1, y.instance_eval{foo})
  end

  test "module_function_private?" do # 最初に定義だとpublicにならない
    x = Module.new
    x.module_eval("module_function")
    x.module_eval("def foo; 0; end")
    if RUBY_VERSION < "1.8"
      assert_raises(NameError){x.foo}
    else
      assert_raises(NoMethodError){x.foo}
    end
  end

  test "module_function_public?" do # 後で指定するとpublicになる。なぜ？
    x = Module.new
    x.module_eval("def foo; 0; end")
    x.module_eval("module_function :foo")
    assert_equal(0, x.foo)
  end

  test "remove_const" do
    Math.const_set("FOO", 123)
    assert_equal(123, Math.const_get("FOO"))
    Math.module_eval{remove_const("FOO")}
  end

  test "remove_method" do
    x = Class.new
    x.class_eval("def foo; 1; end")
    y = Class.new(x)
    y.class_eval("def foo; 2; end")
    a = y.new
    assert_equal(2, a.foo)
    y.instance_eval { remove_method :foo }
    assert_equal(1, a.foo)
  end

  test "undef_method" do
    x = Class.new
    x.class_eval("def foo; 1; end")
    y = Class.new(x)
    y.class_eval("def foo; 2; end")
    a = y.new
    assert_equal(2, a.foo)
    y.class_eval{undef_method :foo}
    if RUBY_VERSION < "1.8"
      assert_raises(NameError){a.foo}
    else
      assert_raises(NoMethodError){a.foo}
    end
  end

  # クラス内のローカル変数の存在
  # 普通のオブジェクトは new した領域に変数が存在するが、その一つ上の領域に存在するのがクラス内のローカル変数
  # クラス変数は継承元の変数まで破壊するが、クラス内のローカル変数はクラスごとに存在する。
  test "class_local_variable" do
    assert_equal(2, C5.class_eval{@v}) # 子クラスの確認
    assert_equal(1, C4.class_eval{@v}) # 親クラスのローカル変数の確認(破壊されていない)
  end
end
