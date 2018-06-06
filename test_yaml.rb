require "./test_helper"
require "yaml"

# https://docs.ruby-lang.org/ja/latest/library/yaml.html
class TestYaml < Test::Unit::TestCase
  test ".dump" do
    assert { YAML.dump({v: 1}) == "---\n:v: 1\n" }
  end

  test ".load" do
    assert { YAML.load("---\n:v: 1\n") == {:v=>1} }
  end
end
# >> Loaded suite -
# >> Started
# >> ..
# >> Finished in 0.008511 seconds.
# >> -------------------------------------------------------------------------------
# >> 2 tests, 2 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> -------------------------------------------------------------------------------
# >> 234.99 tests/s, 234.99 assertions/s
