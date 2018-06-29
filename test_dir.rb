require "./test_helper"

class TestDir < Test::Unit::TestCase
  TMPDIR = File.expand_path("./_tmpdir")

  setup do
    Dir.chdir(__dir__)
    Dir.mkdir(TMPDIR) unless File.exist?(TMPDIR)
    Dir.chdir(TMPDIR) do
      file_create("a.txt")
      file_create("b.txt")
      file_create("x.rb")
      file_create("y.rb")
    end
  end

  teardown do
    if File.directory?(TMPDIR)
      Dir.chdir(TMPDIR) do
        File.delete("a.txt")
        File.delete("b.txt")
        File.delete("x.rb")
        File.delete("y.rb")
      end
      Dir.rmdir(TMPDIR)
    end
  end

  def file_create(filename)
    File.write(filename, "x")
  end

  test ".glob" do
    # ★ これバグてってないか？ glob にフルパスを指定すると base が効いてない。
    files1 = Dir.glob("#{TMPDIR}/*").to_a
    files2 = Dir.glob("#{TMPDIR}/*", base: TMPDIR).to_a
    assert { files1 ==  files2 }

    # こっちは動いている
    files1 = Dir.glob("_tmpdir/*").to_a
    files2 = Dir.glob("_tmpdir/*", base: TMPDIR).to_a
    assert { files1 != files2 }

    assert_equal([TMPDIR], Dir[TMPDIR])
    begin
      pwd = Dir.pwd
      Dir.chdir(TMPDIR)
      assert_equal(%w(a.txt b.txt x.rb y.rb), Dir["*"].sort)
      assert_equal(%w(a.txt b.txt x.rb y.rb), Dir["*.*"].sort)
      assert_equal(%w(a.txt b.txt), Dir["*.txt"].sort)
      assert_equal(%w(a.txt b.txt), Dir["[a-z]*.txt"].sort)
      assert_equal(%w(a.txt b.txt), Dir["*.[^r]*"].sort)
      assert_equal(%w(a.txt b.txt), Dir["{a,b}.txt"].sort)
      assert_equal(%w(a.txt b.txt), Dir["?.txt"].sort)
      assert_equal(%w(a.txt b.txt), Dir.glob("?.txt").sort)

    ensure
      Dir.chdir(pwd)
      assert_equal(pwd, Dir.pwd)
    end
  end

  test "chdir" do
    pwd = Dir.pwd
    assert { Dir.chdir("/tmp") == 0 }
    assert { Dir.pwd == "/private/tmp" }
    assert { Dir.chdir(pwd) == 0 }
    assert { Dir.pwd == pwd }
  end

  test "chroot" do
    # assert_equal(Errno::EPERM, Dir.chroot("/tmp"))
  end

  test "delete_rmdir_unlink" do
    assert { Dir.mkdir("#{TMPDIR}/testdir") == 0 }
    assert { Dir.delete("#{TMPDIR}/testdir") == 0 }
    assert { Dir.mkdir("#{TMPDIR}/testdir") == 0 }
    assert { Dir.rmdir("#{TMPDIR}/testdir") == 0 }
    assert { Dir.mkdir("#{TMPDIR}/testdir") == 0 }
    assert { Dir.unlink("#{TMPDIR}/testdir") == 0 }
  end

  test "entries" do
    assert_equal(%w(. .. a.txt b.txt x.rb y.rb), Dir.entries(TMPDIR).sort)
  end

  test "foreach" do
    x = []
    assert_equal(nil, Dir.foreach(TMPDIR) {|e| x << e})
    assert_equal(%w(. .. a.txt b.txt x.rb y.rb), x.sort)
  end

  test "getwd_pwd" do
    assert_equal(`pwd`.strip, Dir.getwd)
    assert_equal(`pwd`.strip, Dir.pwd)
  end

  test "mkdir" do
    begin
      assert_equal(0, Dir.mkdir("#{TMPDIR}/testdir"))
      assert_equal("40775", ("%o" % File.stat("#{TMPDIR}/testdir").mode))
    ensure
      assert_equal(0, Dir.rmdir("#{TMPDIR}/testdir"))
    end
    begin
      assert_equal(0, Dir.mkdir("#{TMPDIR}/testdir", 0111))
      assert_equal("40111", ("%o" % File.stat("#{TMPDIR}/testdir").mode))
    ensure
      assert_equal(0, Dir.rmdir("#{TMPDIR}/testdir"))
    end
  end

  test "s_new" do
    x = Dir.new(TMPDIR)         # open(TMPDIR)と同じ
    assert_instance_of(Dir, x)
    x.close
  end

  test "s_open_close" do
    x = Dir.open(TMPDIR)
    assert_instance_of(Dir, x)
    assert_equal(nil, x.close)

    # ブロック指定するのが普通
    Dir.open(TMPDIR) {|x|
      assert_instance_of(Dir, x)
    }
  end

  test "read" do
    Dir.open(TMPDIR) {|d|
      ary = []
      6.times do
        ary << d.read
      end
      assert_equal(%w(. .. a.txt b.txt x.rb y.rb), ary.sort)
    }
  end

  test "rewind" do
    Dir.open(TMPDIR) {|d|
      str = d.read
      d.rewind
      assert_equal(str, d.read)
    }
  end

  test "seek" do
    Dir.open(TMPDIR) do |d|
      d.read
      i = d.tell
      str = d.read
      d.seek(i)
      assert_equal(str, d.read)
    end
  end
end
