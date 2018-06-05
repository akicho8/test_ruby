require "./test_helper"

# require "tempfile"

class TestIO < Test::Unit::TestCase
  setup do
    @testfile = "/tmp/testio.txt"
    @data = "01\n23\n45"
    open(@testfile, "w") { |x| x.print @data }
  end

  # 一行ずつ表示する
  # 第2引数には $/ が指定される
  test "s_foreach" do
    assert_equal("\n", $/)
    ary = []
    IO.foreach(@testfile) { |x|ary<<x}
    assert_equal(["01\n", "23\n", "45"], ary)
  end

  # STDERRに出力するのと同じ
  # ブロックの指定は出来ない
  test "s_new" do
    x = IO.new(2, "w")
    # x.print "A"
  end

  # パイプを作る
  test "s_pipe" do
    r, w = IO.pipe
    if fork             # 親の場合、子のpidを返す、子供の場合nilを返す
      # 親の処理
      w.close
      x = r.read
      assert_equal("message to parent", x)
      r.close                   # 子の w.close が発行されるまで待つ
      Process.wait
    else
      # 子供の処理
      r.close
      w.write "message to parent"
      w.close
      exit    # これはいらないけど止めとかないとテストまで実行される (止まってない！？)
    end
  end

  # コマンドを実行して戻り値を取得出来る
  test "s_poepn" do
    assert { IO.popen("uname", &:read) == "Darwin\n" }
  end

  # これがよくわからん
  test "s_poepn2" do
    pid = Process.pid
    IO.popen("-") { |f|
      # 子プロセスで実行される
      # p pid
      # p Process.pid
    }
  end

  # ファイルを配列に読み込む
  test "s_readlines" do
    assert_equal(["01\n", "23\n", "45"], IO.readlines(@testfile))
  end

  test "s_select" do
    # Kernel#select 参照
  end

  test "shift" do
    assert_print("ab") { $stdout << "a" << "b"}
  end

  test "binmode" do
    # Windows環境のみで動作
  end

  # 新しいIOストリームを作成
  test "clone" do
    x = open(@testfile)
    y = x.clone
    assert_equal("0", x.getc)   # 昔は1文字のコード(48)だったが「1文字(列)」が返ようになった
    assert_equal(nil, y.getc)   # ここは49になるはずなのになんで?
  end

  # ファイルを閉じる
  test "close" do
    x = open(@testfile, "w")
    x.close
    assert_raises(IOError) { x.print "A"}
  end

  # 読み込みを閉じる
  test "close_read" do
    x = IO.popen("/bin/sh", "r+")
    x.close_read
    assert_raises(IOError) { x.readlines}
  end

  # 書き込みを閉じる
  test "close_write" do
    x = IO.popen("/bin/sh", "r+")
    x.close_write
    assert_raises(IOError) { x.print "x"}
  end

  # 閉じている？
  test "closed?" do             # close
    x = open(@testfile)
    x.close
    assert_equal(true, x.closed?)
  end

  # 一行毎に読み込む
  test "each" do                        # each_line
    x = []
    open(@testfile) {|f| f.each{|line|x << line}}
    assert_equal(["01\n","23\n","45"], x)
  end

  # 1バイト毎に読み込む
  test "each_byte" do
    x = []
    open(@testfile) {|f| f.each_byte{|c|x << c}}
    assert_equal([48, 49], x[0..1])
  end

  # ファイルの最後に到達した？
  test "eof" do                 # eof?
    x = open(@testfile)
    assert_equal(false, x.eof?)
    x.readlines
    assert_equal(true, x.eof?)
  end

  # ファイル指向の低レベルな操作
  test "fcntl" do
    open(@testfile) {|f|
      assert_equal(true, f.respond_to?(:fcntl))
    }
  end

  # IOストリームの低レベルな操作
  test "ioctl" do
    open(@testfile) {|f|
      assert_equal(true, f.respond_to?(:ioctl))
    }
  end

  # ファイルの番号
  test "fileno" do              # to_i
    assert_equal(0, STDIN.fileno)
    assert_equal(1, STDOUT.fileno)
    assert_equal(2, STDERR.fileno)
  end

  # バッファリングを直ちに出力する
  test "flush" do
    open(@testfile, "w+") {|f|
      f.print "A\n"
      f.flush
      f.rewind
      assert_equal("A\n", f.gets)
    }
  end

  # 一文字入力(最後はnil)
  test "getc" do
    open(@testfile) {|f|
      assert_equal(?0, f.getc)
    }
  end

  # 一行入力(最後はnil)
  test "gets" do
    open(@testfile) {|f|
      assert_equal("01\n", f.gets)
    }
  end

  # ターミナルに接続されているか？
  test "isatty" do              # tty?
    # assert_equal(false, File.new("/dev/tty").tty?)
    # assert_equal(false, File.new(@testfile).tty?)

    # なぜかエラーになってしまう
    # ./testIO.rb:179:in `initialize'(TestIO): No such device or address - "/dev/tty" (Errno::ENXIO)
    # from ./testIO.rb:179:in `new'
  end

  # 読み込んだ行番号の参照と参考
  test "lineno" do              # line=
    open(@testfile) { |f|
      f.readline                # lineno += 1
      f.gets                    # lineno += 1
      assert_equal(2, f.lineno)
      f.lineno = 100
      f.gets                    # lineno += 1
      assert_equal(101, f.lineno)
    }
  end

  # これを実行するとぶっこわれる
  # # パイプのプロセスidの取得
  # test "pid" do
  #   pipe = IO.popen("-")
  #   if pipe
  #     # 親
  #     # $stderr.puts "#{pipe.pid}"
  #     pid = pipe.pid
  #     pipe.close
  #   else
  #     # 子
  #     # $stderr.puts "#{$$}"
  #     exit
  #   end
  # end

  # ファイルポジションの取得と設定
  test "pos" do                 # tell pos=
    open(@testfile) {|f|
      assert_equal(0, f.pos)
      f.pos = 1
      assert_equal("1"[0], f.getc)
    }
  end

  # 文字列出力
  test "print" do
    assert_print("AB") {  $stdout.print "A","B"}
  end

  # 文字列では無いオブジェクトは to_s される
  test "write" do
    assert_print("A") { $stdout.write "A"}
    assert_print("1") { $stdout.write 1}
  end

  # 書式付出力
  test "printf" do
    assert_print("a") { $stdout.printf("%x", 10)}
  end

  # 一文字出力
  test "putc" do
    assert_print("A") { $stdout.putc(0x41)}
  end

  # 文字列出力改行付き
  test "puts" do
    assert_print("A\nB\n") { $stdout.puts("A", "B")}
  end

  # 指定バイト数読み込み
  test "read" do
    open(@testfile) { |f|
      assert_equal("01", f.read(2))
      f.read                    # 引数が無ければ残り全部読み込む
      assert { f.read(0) == "" } # 昔は nil だった
    }
  end

  # 一文字読み込み (最後は例外)
  test "readchar" do
    open(@testfile) { |f|
      x = ""
      assert_raises(EOFError) { loop {x << f.readchar}}
      assert_equal(@data, x)
    }
  end

  # 一行読み込み (最後は例外)
  test "readline" do
    open(@testfile) { |f|
      x = ""
      assert_raises(EOFError) { loop {x << f.readline}}
      assert_equal(@data, x)
    }
  end

  # 行を配列として読み込む
  test "readlines" do
    x = open(@testfile)
    assert_equal(["01\n","23\n","45"], x.readlines)
  end

  # IOを繋ぎ帰る(Arrayのreplaceのような機能)
  test "reopen" do
    x = open(@testfile)
    y = open(@testfile)
    assert_equal("01\n", y.readline)
    y.reopen(x)
    assert_equal("01\n", y.readline)
  end

  # ファイルポジションを先頭に移動する
  test "rewind" do
    open(@testfile, "w+") {|f|
      f.print "A\n"
      f.flush
      f.rewind
      assert_equal("A\n", f.gets)
    }
  end

  # ファイルポジションを変更する (C言語風)
  test "seek" do
    open(@testfile) {|f|
      f.seek(4, IO::SEEK_SET)
      assert_equal(4, f.pos)
      f.seek(+2, IO::SEEK_CUR)
      assert_equal(6, f.pos)
      f.seek(-4, IO::SEEK_END)
      assert_equal(File.size(@testfile)-4, f.pos)
    }
  end

  # File::Stat オブジェクトを返す
  test "stat" do
    assert { ("%o" % open(@testfile).stat.mode) == "100664" }
  end

  # バッファリングの許可/禁止
  test "sync" do                        # sync=
    open(@testfile, "w+") {|f|
      # バッファリング有り
      assert_equal(false, f.sync)
      f.print "A\n"
      # バッファリング無し
      f.sync = true
      assert_equal(true, f.sync)
      f.print "B\n"
    }
  end

  # 低レベルな指定バイト数読み込み
  test "sysread" do
    open(@testfile) {|f|
      assert_equal("01", f.sysread(2))
    }
  end

  # 低レベルな指定バイト書き込み
  test "syswrite" do
    open(@testfile, "w+") {|f|
      assert_equal(2, f.syswrite("AB"))
    }
  end

  # IOオブジェクトを返す
  test "to_io" do
    assert_equal(STDOUT, STDOUT.to_io)
  end

  # 一文字戻す (C言語風)
  test "ungetc" do
    open(@testfile, "r") {|f|
      assert_equal(?0, f.getc)
      f.ungetc(?a)
      assert_equal(?a, f.getc)
      assert_equal(?1, f.getc)
    }
  end
end
# ~> /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/ui/console/testrunner.rb:465:in `write': Broken pipe @ io_write - <STDOUT> (Errno::EPIPE)
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/ui/console/testrunner.rb:465:in `puts'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/ui/console/testrunner.rb:465:in `output'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/ui/console/testrunner.rb:459:in `nl'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/ui/console/testrunner.rb:119:in `finished'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/util/observable.rb:78:in `block in notify_listeners'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/util/observable.rb:78:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/util/observable.rb:78:in `notify_listeners'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/ui/testrunnermediator.rb:50:in `ensure in run'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/ui/testrunnermediator.rb:50:in `run'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/ui/testrunner.rb:40:in `start_mediator'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/ui/testrunner.rb:25:in `start'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/ui/testrunnerutilities.rb:24:in `run'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/autorunner.rb:435:in `block in run'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/autorunner.rb:491:in `change_work_directory'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/autorunner.rb:434:in `run'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit/autorunner.rb:62:in `run'
# ~> 	from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/test-unit-3.2.8/lib/test/unit.rb:502:in `block (2 levels) in <top (required)>'
# ~> !XMP1528165428_8449_414868![1] => String "100664"
# ~> _xmp_1528165428_8449_952235
