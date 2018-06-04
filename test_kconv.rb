require "./test_helper"

require "kconv"

class TestKConv < Test::Unit::TestCase
  test "(methods)" do
    assert { "あ".toutf8.encoding.name == "UTF-8" }
    assert { "あ".toeuc.encoding.name == "EUC-JP" }
    assert { "あ".tosjis.encoding.name == "Shift_JIS" }
    assert { "あ".tojis.encoding.name == "ISO-2022-JP" }
  end
end
