require "./test_helper"
require "pathname"
require "fileutils"

class TestPathname < Test::Unit::TestCase
  setup do
    Pathname.new("testdir").mkpath
    Pathname.new("testdir/__test.txt").open("w"){|f| f << "test"}
  end

  teardown do
    Pathname.new("testdir").rmtree
  end

  test "main" do
    obj = Pathname.new("testdir/__test.txt")

    assert_equal("testdir/__test.txt",                   obj.to_s)          # ファイル名を参照する
    assert_equal(File.size("testdir/__test.txt"),        obj.size)          # サイズの取得。他にも似たメソッドがたくさんある。
    assert_equal(File.directory?("testdir/__test.txt"),  obj.directory?)    # ディレクトリか?
    assert_equal(File.expand_path("testdir/__test.txt"), obj.realpath.to_s) # 絶対パスを取得
    assert_equal("testdir",                              obj.parent.to_s)   # 親ディレクトリを取得

    assert_equal(true, Pathname.new("/boot").mountpoint?)  # マウント位置か?
    assert_equal(true, Pathname.new("/").root?)            # ルートか? "//" となっていてもルートと見なされる。
    assert_equal(true, Pathname.new("/usr/bin").absolute?) # 絶対パスか?
    assert_equal(true, Pathname.new("foo/bar").relative?)  # 相対パスか?

    assert_equal("foo/foo.txt",  Pathname.new(".//foo//foo.txt//").cleanpath.to_s)       # 汚ないパスを綺麗にする
    assert_equal("foo/foo.txt/", Pathname.new(".//foo//foo.txt//").cleanpath(true).to_s) # true にすると最後の / が消えない(?)

    # /usr/local/bin に対して /usr からの相対パスを取得する
    assert_equal("local/bin", Pathname.new("/usr/local/bin").relative_path_from(Pathname.new("/usr")).to_s)

    # each_filename は split(%r{/}).each のようなものだけと名前が分かりやすい。でもあまり使わない。
    ary = []
    Pathname.new("foo/bar").each_filename{|f|ary << f}
    assert_equal(%w(foo bar), ary)

    # Find.find を使う方法
    Pathname.new(".").find{}

    # mkdirとmkpathの違いに注意。
    assert_raises(Errno::EEXIST){Pathname.new("testdir").mkdir}

    Pathname.new("testdir/a/b/c").mkpath
    Pathname.new("testdir/a/b/c").mkpath # FileUtils.mkdir_p を使っているのでエラーはなし。

    Pathname.new("testdir/a").rmtree # 一度目の削除
    assert_raises(Errno::ENOENT){Pathname.new("testdir/a").rmtree} # 二度目の削除はエラー。rm_fr ではなく rm_r を使っている。
  end

  # パスの結合。File.join と異なり、絶対パスが接続されると置き換わる。
  test "join" do
    # + を使う場合
    assert_equal("/usr/bin", (Pathname.new("/usr") + "bin").to_s)
    assert_equal("/bin",     (Pathname.new("/usr") + "/bin").to_s)

    # join を使う場合
    assert_equal("/usr/bin", Pathname.new("/usr").join("bin").to_s)
    assert_equal("/bin",     Pathname.new("/usr").join("/bin").to_s)
  end

  # サブディレクトリのファイル一覧を返す Dir[] に対応
  test "children" do
    assert_kind_of(Array, Pathname.new(".").children)       # 現地点からの相対パスで返す
    assert_kind_of(Array, Pathname.new(".").children(true)) # パスを除いて返す
  end
end
