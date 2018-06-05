require "./test_helper"
require "find"

# https://docs.ruby-lang.org/ja/latest/class/Find.html
class TestFind < Test::Unit::TestCase
  # ignore_error: true がデフォルト
  test "find" do
    assert { Find.find("/bin", "/usr/bin", ignore_error: true).class == Enumerator }
  end

  # next より協力なやつ
  test "prune" do
    Find.find("/usr") do |f|
      if f == "/usr/bin"        # 必ずディレクトリのチェック
        Find.prune # 配下をスキップ(ブロックに渡されたのがディレクトリの場合のみ機能する)
      end
      # next の場合はスキップするだけ
      break
    end
  end
end
