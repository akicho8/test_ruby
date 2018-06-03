require "./test_helper"

class TestFile < Test::Unit::TestCase
  setup do
    @file = "/tmp/foo.txt"
    open(@file, "w") {|e|e.print "x"*1024}
    @zerofile = "/tmp/zero.txt"
    open(@zerofile, "w").close
    @symfile = "/tmp/sym.txt"
    File.symlink(@file, @symfile) unless File.exist?(@symfile)
  end

  teardown do
    begin
      File.delete(@file, @zerofile, @symfile)
    rescue
    end
  end

  test "separator" do
    assert_equal(nil, File::ALT_SEPARATOR)
    assert_equal(":", File::PATH_SEPARATOR)
    assert_equal("/", File::SEPARATOR)
    assert_equal("/", File::Separator)
  end

  test "s_atime" do
    assert_instance_of(Time, File.atime(@file))
  end

  test "s_basename" do
    assert_equal("foo.txt", File.basename(@file))
    assert_equal("foo", File.basename(@file, ".txt"))
  end

  test "s_chmod" do
    assert_equal(1, File.chmod(0644, @file))
    assert_equal(2, File.chmod(0644, @file, @file))
  end

  test "s_chown" do
    assert_equal(1, File.chown(nil, nil, @file))
    assert_equal(2, File.chown(nil, nil, @file, @file))
  end

  test "s_ctime" do
    assert_instance_of(Time, File.ctime(@file))
  end

  test "s_delete" do
    assert_equal(2, File.delete(@file, @zerofile))
  end

  test "s_dirname" do
    assert_equal("/tmp", File.dirname(@file))
  end

  test "s_expand_path" do
    assert_equal("#{ENV['HOME']}/ikeda", File.expand_path("~/ikeda"))
  end

  test "s_ftype" do
    assert_equal("file", File.ftype(@file))
    assert_equal("file", File.ftype("/usr/bin/perl"))
    # assert_equal("file", File.ftype("/proc/meminfo"))
    assert_equal("link", File.ftype("/tmp"))
    # assert_equal("directory", File.ftype("/proc"))
    # assert_equal("blockSpecial", File.ftype("/dev/hda"))
    assert_equal("link", File.ftype(@symfile))
    assert_equal("characterSpecial", File.ftype("/dev/tty"))
    # assert_equal("socket", File.ftype("/tmp/.X11-unix/X0"))
  end

  test "s_join" do
    assert_equal("/", File::SEPARATOR)
    assert_equal("a/b/c", File.join("a", "b", "c"))
  end

  test "s_link" do
    begin
      x = "/tmp/hardlink.txt"
      File.delete(x) if File.exist? x
      assert_equal(0, File.link(@file, x))
      assert_equal(IO.readlines(@file), IO.readlines(x))
    ensure
      File.delete(x) if File.exist? x
    end
  end

  test "s_lstat" do
    assert_equal(true, File.stat(@symfile).size == 1024)
    assert_equal(true, File.lstat(@symfile).size != 1024)
  end

  test "s_mtime" do             # 最終アクセス日
    assert_instance_of(Time, File.mtime(@file))
  end

  test "s_new" do
    x = File.new(@file, "w")
    x.close
    x = File.new(@file, File::CREAT|File::TRUNC|File::RDWR)
    x.close
  end

  test "s_open" do
    x = File.open(@file, "w")
    assert_instance_of(File, x)
    x.print "x"
    x.close

    x = File.open(@file, "w") {|f| f.print "x"}
    assert_equal(nil, x)
  end

  test "s_open_attr_error_case1" do
    # openの第二引数が文字列の場合、第３引数の属性は無効になる
    File.open(@file, "w", 0755) {}
    assert_equal("100664", "%0o" % File.stat(@file).mode)
  end

  test "s_open_attr_error_case2" do
    # openの第二引数が数値だけど、新規ファイルの作成では無いので反映されない
    File.open(@file, File::CREAT|File::TRUNC|File::RDWR, 0755) {}
    assert_equal("100664", "%0o" % File.stat(@file).mode)
  end

  test "s_open_attr_ok" do
    # openの第二引数が数値でかつ、新規ファイルの作成だった場合にのみ第３引数の属性値は反映される
    File.delete(@file)
    File.open(@file, File::CREAT|File::TRUNC|File::RDWR, 0755) {}
    assert_equal(0100755, File.stat(@file).mode)
  end

  test "s_readlink" do
    assert_equal(@file, File.readlink(@symfile))
  end

  test "s_rename" do
    assert_equal(0, File.rename(@file, "/tmp/foo.txt.bak"))
    assert_equal(1, File.delete("/tmp/foo.txt.bak"))
  end

  test "s_size" do
    assert_equal(1024, File.size(@file))
    assert_equal(1024, File.size(@symfile))
    assert_equal(0, File.size(@zerofile))
  end
  # パスとファイル名分離

  test "s_split" do
    assert_equal(["/tmp", "foo.txt"], File.split(@file))
    assert_equal(["/foo/bar", "baz"], File.split("/foo/bar/baz"))
    assert_equal(["/foo/bar/baz", ""], File.split("/foo/bar/baz/")) if RUBY_VERSION <= "1.6"
    assert_equal(["/foo/bar", "baz"],  File.split("/foo/bar/baz/")) if RUBY_VERSION >= "1.8"
  end

  test "s_stat" do
    x = File.stat(@file)
    assert_instance_of(File::Stat, x)
  end

  test "s_symlink" do
    assert_equal(false, File.exist?("/tmp/symlink.txt"))
    File.symlink(@file, "/tmp/symlink.txt")
    assert_equal(true, File.exist?("/tmp/symlink.txt"))
    File.delete("/tmp/symlink.txt")
  end

  test "s_truncate" do
    File.truncate(@file, 2048)
    assert_equal(2048, File.size(@file))
    File.truncate(@file, 0)
    assert_equal(0, File.size(@file))
  end

  test "s_umask" do
    old = File.umask
    File.umask(0006)
    assert_equal(0006, File.umask)
    File.umask(old)
  end

  test "s_unlink" do
    assert_equal(1, File.unlink(@file))
  end

  test "s_utime" do             # 最終アクセス日と更新日
    assert_equal(1, File.utime(0, 0, @file))
    assert_equal(1, File.utime(Time.now, Time.now, @file))
  end
  # --------------------------------------------------------------------------------

  test "atime" do
  end

  test "chmod" do
  end

  test "chown" do
  end

  test "ctime" do
  end

  test "flock" do
    assert_equal(0, File.new(@file).flock(File::LOCK_UN)) # 排他
    assert_equal(0, File.new(@file).flock(File::LOCK_SH)) # 共有
    assert_equal(0, File.new(@file).flock(File::LOCK_UN|File::LOCK_NB)) # 排他(ブロックしない)
    assert_equal(0, File.new(@file).flock(File::LOCK_SH|File::LOCK_NB)) # 共有(ブロックしない)
    assert_equal(0, File.new(@file).flock(File::LOCK_UN)) # 解除
  end

  test "lstat" do
  end

  test "mtime" do
  end

  test "path" do
    assert_equal(@file, File.new(@file, "w").path)
  end

  test "truncate" do
  end
end
