require "test/unit"
require "org_tp"

$VERBOSE = true

module Test::Unit::Assertions
  def assert_print(except)
    save_stdout = $stdout
    tempfile = Tempfile.new("stdout")
    $stdout = tempfile
    yield
    $stdout = save_stdout
    tempfile.close
    assert_equal(except, IO.readlines(tempfile.path).join)
  end
end
