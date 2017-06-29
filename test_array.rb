require "test/unit"

# https://docs.ruby-lang.org/ja/2.4.0/class/Array.html
class TestArray < Test::Unit::TestCase
  test "bsearch, bsearch_index" do
    assert_equal("c", %w(a b c d e).bsearch {|e| e >= "c"})      # find-minimum
    assert_equal("c", %w(a b c d e).bsearch {|e| e <=> "c"})     # find-any
    assert_equal(2, %w(a b c d e).bsearch_index {|e| e >= "c"})  # find-minimum
    assert_equal(2, %w(a b c d e).bsearch_index {|e| e <=> "c"}) # find-any
  end
end
# >> Loaded suite -
# >> Started
# >> .
# >> 
# >> Finished in 0.00039 seconds.
# >> ------
# >> 1 tests, 4 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> ------
# >> 2564.10 tests/s, 10256.41 assertions/s
