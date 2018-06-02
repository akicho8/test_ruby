require "rspec/autorun"
require "org_tp"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should, :expect]
  end
  config.expect_with :test_unit

  # config.around(:example, remove_const: true) do |example|
  #   const_before = Object.constants
  #   example.run
  #   const_after = Object.constants
  #   (const_after - const_before).each do |const|
  #     p [:remove_const, const]
  #     Object.send(:remove_const, const)
  #   end
  # end
end
