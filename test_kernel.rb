require "./test_helper"

# 独自のエラー定義
class OriginalException < Exception; end

# https://docs.ruby-lang.org/ja/latest/class/Kernel.html
class TestKernel < Test::Unit::TestCase
  # 変数名が格納された配列のダンプ用
  def vars_dump(ary)
    ary.each{|e|eval %q{
        print "#{e}=#{eval(e).inspect}\n"
      }
    }
  end

  test "etc" do
    assert_equal(true, Object.included_modules.include?(Kernel))
  end

  # 配列を生成
  test "Array" do
    assert_equal([1,2,3], Kernel.Array(1..3))
  end

  # 小数を生成("3.14A"などはエラーになる)
  test "Float" do
    assert_equal(1.0, Kernel.Float(1))
    assert_equal(0.0, Kernel.Float(nil)) if RUBY_VERSION < "1.8"
    assert_equal(3.14, Kernel.Float("3.14"))
    assert_raises(ArgumentError){Kernel.Float("3.14A")}
    assert_raises(ArgumentError){Kernel.Float("")}
  end
  # 数値を生成(String#to_iでは 0x 0b 0 に対応してないのでこのメソッドは便利!)

  test "Integer" do
    assert_equal(3, Kernel.Integer(3.14))
    assert_equal(16, Kernel.Integer("0x10"))
    assert_equal(2, Kernel.Integer("0b10"))
    assert_equal(8, Kernel.Integer("010"))
    assert_equal(1234, Kernel.Integer(Time.at(1234)))
    assert_raises(ArgumentError){Kernel.Integer("3.14A")}
  end
  # サブシェルで実行結果を戻す

  test "backquote" do
    assert_equal("Hello", `echo -n Hello`)
    assert_equal("Hello", %x{echo -n Hello})
  end
  # Kernel.exit(1) と同じ

  test "abort" do
    # Kernel.abort
    assert_equal(true, Kernel.respond_to?(:abort))
  end
  # 終了時の処理を登録

  test "at_exit" do             # exit, exit!
    assert_equal(true, Kernel.respond_to?(:at_exit))
  end
  # at_exitでの登録内容はスキップして終了
  def __test_at_exit_A
    Kernel.at_exit{p "A"}
    Kernel.at_exit{p "B"}
    exit!
  end
  # ato_exitの内容を実行して終了("B" "A" の順に表示される)
  def __test_at_exit_B
    Kernel.at_exit{p "A"}
    Kernel.at_exit{p "B"}
    exit
  end

  # 遅延 require

  test "autoload" do
    file = "/tmp/ruby_autoload_test.rb"
    create_module_for_autoload(file)
    Kernel.autoload :TestAutoLoad, file # この時点では require されていない
    assert_equal("OK", TestAutoLoad.foo) # この時点で require される
  end
  def create_module_for_autoload(file)
    open(file, "w") {|f|
      f.print %q{               # %q{}を使うとインデントが正常に保たれる!
        module TestAutoLoad
          module_function
          def foo
            "OK"
          end
        end
      }
    }
  end

  # 環境の保存(こんな物までオブジェクトになっているとは凄い)
  def get_binding(arg)
    binding
  end

  test "binding" do
    assert_equal("OK", eval(%q{arg}, get_binding("OK")))
  end

  # ブロックが与えられているか?

  test "block_given?" do
    assert_raises(LocalJumpError){yield}
    assert_raises(LocalJumpError){block_try}
    assert_equal(true, block_try2{})
    assert_equal(false, block_try2)
  end
  def block_try
    yield
  end
  def block_try2
    Kernel.block_given?
  end

  # Continuationオブジェクトの生成(ブロックの中で call を呼ぶと復帰する)

  test "callcc" do
    m = 0
    x = Kernel.callcc{|cc| cc.call(4); m=1}
    assert_equal(m, 0)
    assert_equal(x, 4)
  end

  # コールスタックの表示(引数を指定分だけ古いスタック情報を省略する)

  test "caller" do
    x = caller
    # p x
    # ["/usr/lib/ruby/1.6/runit/testcase.rb:64:in `send'", "/usr/lib/ruby/1.6/runit/testcase.rb:64:in `run_bare'", "/usr/lib/ruby/1.6/runit/testcase.rb:51:in `run'", "/usr/lib/ruby/1.6/runit/testsuite.rb:16:in `run'", "/usr/lib/ruby/1.6/runit/testsuite.rb:16:in `each'", "/usr/lib/ruby/1.6/runit/testsuite.rb:16:in `run'", "/usr/lib/ruby/1.6/runit/cui/testrunner.rb:26:in `run'", "/usr/lib/ruby/1.6/runit/cui/testrunner.rb:20:in `run'", "./testKernel.rb:130"]
    x = caller(8)
    # p x
    # ["/usr/lib/ruby/1.6/runit/cui/testrunner.rb:20:in `run'", "./testKernel.rb:137"]

  end

  # ブロックを実行して throw でジャンプして catch で捕捉する

  test "catch" do               # throw
    assert_equal("throw", catch(:done) {catch_test(true)})
    assert_equal("end",   Kernel.catch(:done) {catch_test(false)})
  end
  def catch_test(x)
    Kernel.throw :done, "throw" if x
    "end"
  end

  # String#chomp と似ているけどレシーバーは $_ のみ
  # $_ = $_.chomp(str) と同等

  test "chomp" do
    $_ = "foo\r\n"
    chomp
    if RUBY_VERSION < "1.8"
      assert_equal("foo\r", $_) # \rまでは削除されない
      chomp
      assert_equal("foo\r", $_) # 再び実行しても chop じゃないので \r は削除されない
      chomp("\r")
      assert_equal("foo", $_)   # 自分で削除する文字列を指定すると削除出来る
    else
      assert_equal("foo", $_)
    end
  end

  # $_.chomp!(str) と同等

  test "chomp!" do
    $_ = "foo"
    assert_equal(nil, chomp!("x")) # fooにxは含まれないので nil を返した
    assert_equal("foo", chomp("x")) # chomp の場合はレシーバーに代入なので元の値になる
  end

  test "chop" do
    $_ = "foo\r\n"
    assert_equal("foo", chop)   # "\r\n"を一気に消してくれるので便利!
    assert_equal("foo", $_)
    assert_equal("fo", chop)
    assert_equal("fo", $_)
  end

  test "chop!" do
    $_ = "foo\r\n"
    assert_equal("foo", chop!)
    assert_equal("foo", $_)
    assert_equal("fo", chop!)
    assert_equal("fo", $_)
    assert_equal("f", chop!)
    assert_equal("", chop!)
    assert_equal(nil, chop!)
  end

  test "eval" do
    assert_equal("OK", eval(%q{arg}, get_binding("OK")))
    x = 1
    assert_equal(3, eval("x+2"))
  end

  test "fork" do
    return if $0 != __FILE__
    assert_raises(Errno::ECHILD){Process.wait}
    2.times{Kernel.fork{}}
    2.times{Process.wait}
    assert_raises(Errno::ECHILD){Process.wait}
  end

  test "global_variables" do
    x = global_variables
    assert_instance_of(Array, x)

    # vars_dump(global_variables)
    # $VERBOSE=false
    # $LOAD_PATH=["/home/ikeda/lib/ruby", "/usr/local/lib/site_ruby/1.6", "/usr/local/lib/site_ruby/1.6/i386-linux", "/usr/local/lib/site_ruby", "/usr/lib/ruby/1.6", "/usr/lib/ruby/1.6/i386-linux", "."]
    # $stdin=#<IO:0x40274090>
    # $\=nil
    # $~=nil
    # $0="./testKernel.rb"
    # $-K="NONE"
    # $DEBUG=false
    # $-i=nil
    # $>=#<IO:0x4027407c>
    # $'=nil
    # $@=nil
    # $-a=false
    # $-I=["/home/ikeda/lib/ruby", "/usr/local/lib/site_ruby/1.6", "/usr/local/lib/site_ruby/1.6/i386-linux", "/usr/local/lib/site_ruby", "/usr/lib/ruby/1.6", "/usr/lib/ruby/1.6/i386-linux", "."]
    # $-0="\n"
    # $-l=false
    # $?=0
    # $KCODE="NONE"
    # $-w=false
    # $FILENAME="-"
    # $stderr=#<IO:0x40274068>
    # $_=nil
    # $`=nil
    # $-F=nil
    # $:=["/home/ikeda/lib/ruby", "/usr/local/lib/site_ruby/1.6", "/usr/local/lib/site_ruby/1.6/i386-linux", "/usr/local/lib/site_ruby", "/usr/lib/ruby/1.6", "/usr/lib/ruby/1.6/i386-linux", "."]
    # $/="\n"
    # $-p=false
    # $$=18085
    # $==false
    # $-v=false
    # $"=["runit/testcase.rb", "observer.rb", "runit/testsuite.rb", "runit/robserver.rb", "runit/error.rb", "runit/assert.rb", "runit/version.rb", "runit/setuppable.rb", "runit/method_mappable.rb", "runit/teardownable.rb", "runit/cui/testrunner.rb", "runit/testresult.rb", "runit/testfailure.rb", "assert_print.rb", "tempfile.rb", "delegate.rb", "/tmp/ruby_autoload_test.rb"]
    # $stdout=#<IO:0x4027407c>
    # $.=8
    # $&=nil
    # $;=nil
    # $*=[]
    # $<=-
    # $,=nil
    # $SAFE=0
    # $-d=false
    # $defout=#<IO:0x4027407c>
    # $+=nil
    # $!=nil
  end

  test "local_variables" do
    x = 0
    y = 0
    assert_equal(["x", "y"], local_variables)
  end

  test "gsub" do                        # gsub!
    assert_equal(0, 0)
  end

  test "proc" do                # lambda
    assert_equal(1, block_run(1) {|e|e}) # 外に書く場合
    assert_equal(1, block_run(1,&proc{|e|e}))   # 引数に書く場合は & をつける
    x = proc{|e|e}
    assert_equal(1, block_run(1, &x)) # 引数に書く場合は & をつける
    assert_equal(nil, block_run(1)) # ブロックを指定しなければ block=nil となる
  end
  def block_run(x, &block)      # ブロックの指定がなければ block=nil
    if Kernel.block_given?
      block.call(x)
    else
      block                     # 必ず nil になる
    end
  end

  # require と同じコードだけど拡張子を含めてファイル名を指定しなければならない
  # load file, true とするとグローバル名前空間を汚さない

  test "load" do
    unless $".include?("thread.rb")
      Kernel.load 'thread.rb'
    end
  end

  # 無限ループ

  test "loop" do
    x = 1
    Kernel.loop{x=2;break;x=3}
    assert_equal(2, x)
  end

  # ファイルを開く

  test "open" do
    x = Kernel.open("/tmp/opentest.tmp", "w") {|f| f << "OK\n"}
    assert_equal(true, x.closed?)
  end

  # 子プロセスを生成して出力を読み取る方法

  test "open_2" do
    open("|uname"){|f|
      assert_equal("Linux\n", f.gets)
    }
  end

  # 子プロセスを生成して同じ Ruby スクリプトを実行
  # これもよくわからない

  test "open_3" do
    open("|-") {|f|
      if f == nil
        puts "in child"
      else
        x = f.gets
        assert_equal("in child\n", x)
      end
    }
  end

  # デバッグ表示

  test "p" do
    assert_print("[1, 2]\n"){Kernel.p [1,2]}
  end

  # $defout に出力される

  test "print" do
    assert_print("Hello") {Kernel.print "Hello"}
  end

  # 書式付き表示

  test "printf" do
    assert_print("1010") {Kernel.printf("%b", 10)}
  end

  # 一文字表示
  # Kernel.putc とやったらエラーになる
  # putcもエラーになった

  test "putc" do
    assert_print("A") {$defout.putc(0x41)}
  end

  # 改行付き文字列表示

  test "puts" do
    assert_print("A\nB\n") {$defout.puts("A","B")}
  end

  # 乱数

  test "rand" do
    # 0..3 の乱数を 100 個生成して本当に 0..3 の間にあるか調べる
    assert_equal([true], (0...100).map{rand(4).between?(0, 3)}.uniq)
    # 引数が無ければ小数
    assert_equal(true, rand.between?(0.0, 1.0))
  end

  # 乱数の種子設定

  test "srand" do
    x = srand(1)
    assert_equal(true, rand(2).between?(0, 1))
    srand(x)
  end

  # ライブラリの読み込み (最初に一回だけ)

  test "require" do
    require "runit/testcase"    # 最初に一度しか読み込まれない
    assert_equal(true, $".include?("runit/testcase.rb")) # 読み込まれると $" の配列に追加される
  end

  # 指定時間待つ

  test "sleep" do
    # sleep                     # 引数が無ければ無限に停止する
    assert_equal(0, sleep(0))
  end

  def __test_syscall
    Kernel.syscall 4, 1, "hello", "hello".length #=> "hello"
  end

  test "system" do
    assert_equal(true,  system("echo -n")) # コマンド発見
    assert_equal(0, $?)
    assert_equal(true,  system("echo", "-n")) # コマンド発見(引数をわけても良い)
    assert_equal(0, $?)
    assert_equal(false, system("echo2 -n")) # コマンドが無い
    assert_equal(32512, $?)
  end

  # EOFでEOFErrorを発生する点をのぞいて Kernel.gets と同じ

  test "readline" do
  end

  # Kernel.getsを呼び続けて配列を返す

  test "readlines" do
  end

  # $_ を操作するの無視

  test "gets" do
  end

  test "scan" do
  end

  test "split" do
  end

  test "sub" do                 # sub!
  end

  # ファイルテスト(p509)

  test "test" do
    assert_equal(true, test(?e, $0)) # ファイルが存在するか?
  end

  # グローバル変数の代入監視
  # 設定された値を足していくサンプル
  # proc の所は文字列でもいい
  # trace_var :$_, "p $_" こんな風に
  # でも設定された値が取得できないので出来るだけ proc {|e|} で指定したほうがいい

  test "trace_var" do           # untrace_var
    x = 0
    trace_var :$_, proc {|e| x += e}
    $_ = 1
    $_ = 2
    assert_equal(2, $_)         # 参照の場合、ブロックは実行されない
    assert_equal(3, x)

    # トレースを解除したので x は変化しない
    untrace_var :$_
    $_ = 1
    assert_equal(3, x)
  end

  # プロセス間の最低限の通信

  test "trap" do
    return if $0 != __FILE__

    # trap 0, proc{p "A"}  # 終了時に実行される
    x = 1
    trap("CLD") {x += 1}        # 子プロセスが死んだ時に呼ばれるみたい
    fork{}
    Process.wait
    assert_equal(2, x)
  end

  # 入出力デバイスでデータが使用可能になるまで待つ
  # らしいけど、はっきりいってこれは何に使うのか読んでもわからん

  test "select" do
    assert_equal([[$stdin], [], []], select([$stdin], nil, nil, 0.1)) if RUBY_VERSION < "1.8"
  end

  # トレース
  #     line    testKernel.rb:409 test_set_trace_func TestKernel
  #     line    testKernel.rb:410 test_set_trace_func TestKernel
  #   c-call    testKernel.rb:410   set_trace_func   Kernel

  test "set_trace_func" do
    output = []
    set_trace_func proc {|event, file, line, id, binding, classname|
      output << "%8s %16s:%-3d %16s %8s\n" % [event, File.basename(file), line, id, classname]
    }
    x = 1
    set_trace_func(nil)         # 解除
    assert_equal(3, output.size)
  end

  # singleton_method_add は同じレベル(self)にあるメソッドが追加したら呼ばれる
  # サブクラスに追加されたときに呼ばれる門だと勘違いしていた
  # 以下のコードを見るとクラスもインスタンスもまったく同じ物という事がわかる

  test "singleton_method_added" do

    # クラスレベル
    klass = Class.new
    def klass.singleton_method_added(id)
      @xxx ||= []; @xxx << id
    end
    def klass.foo; end
    assert_equal([:singleton_method_added, :foo], klass.instance_eval(%q{@xxx}))

    # インスタンスレベル
    obj = klass.new
    def obj.singleton_method_added(id)
      @xxx ||= []; @xxx << id
    end
    def obj.bar; end
    assert_equal([:singleton_method_added, :bar], obj.instance_eval(%q{@xxx}))
  end

  # systemと似てるけど実行すると戻って来ない
  # 現在のプロセスを置き換える
  def __test_exec
    exec("ls", "-al")
  end

  # 例外 fail と同じ

  test "raise" do
    assert_raises(RuntimeError) {raise}
    assert_raises(RuntimeError) {raise "Hoge Error"}
    assert_raises(ArgumentError) {raise ArgumentError}
    assert_raises(ArgumentError) {raise ArgumentError, "No Parameters"}
    assert_raises(ArgumentError) {raise ArgumentError, "No Parameters", caller}
    assert_raises(OriginalException) {raise OriginalException, "Original Error", caller}
  end

  # sprintfと同じ

  test "format" do
    assert_equal("1010", Kernel.format("%b", 10))
    assert_equal("1010", Kernel.sprintf("%b", 10))
    assert_equal("1010", "%b" % 10)
  end
end
