require "./test_helper"
require "find"

# https://docs.ruby-lang.org/ja/latest/class/Find.html
class TestFind < Test::Unit::TestCase
  # ignore_error: true $B$,%G%U%)%k%H(B
  test "find" do
    assert { Find.find("/bin", "/usr/bin", ignore_error: true).class == Enumerator }
  end

  # next $B$h$j6(NO$J$d$D(B
  test "prune" do
    Find.find("/usr") do |f|
      if f == "/usr/bin"        # $BI,$:%G%#%l%/%H%j$N%A%'%C%/(B
        Find.prune # $BG[2<$r%9%-%C%W(B($B%V%m%C%/$KEO$5$l$?$N$,%G%#%l%/%H%j$N>l9g$N$_5!G=$9$k(B)
      end
      # next $B$N>l9g$O%9%-%C%W$9$k$@$1(B
      break
    end
  end
end
