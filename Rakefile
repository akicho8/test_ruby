require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.verbose = true
  t.test_files = FileList["test_*.rb"]
end

task default: :test
