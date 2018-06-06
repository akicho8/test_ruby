require "test/unit"
require "org_tp"
require "tempfile"

$VERBOSE = true

module Test::Unit::Assertions
  # from /usr/local/var/rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/activesupport-5.2.0/lib/active_support/testing/stream.rb
  def capture(stream)
    stream = stream.to_s
    captured_stream = Tempfile.new(stream)
    stream_io = eval("$#{stream}")
    origin_stream = stream_io.dup
    stream_io.reopen(captured_stream)

    yield

    stream_io.rewind
    captured_stream.read
  ensure
    captured_stream.close
    captured_stream.unlink
    stream_io.reopen(origin_stream)
  end
end
