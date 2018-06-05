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
# >> Loaded suite -
# >> Started
# >> .
# >> Finished in 0.008076 seconds.
# >> -------------------------------------------------------------------------------
# >> 1 tests, 4 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 123.82 tests/s, 495.29 assertions/s
