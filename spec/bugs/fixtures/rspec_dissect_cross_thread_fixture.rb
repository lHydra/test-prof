# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../../../../lib", __FILE__)
require "test-prof"

# Evaluating a memoized helper (`let`) from a thread other than the RSpec
# example thread must not crash RSpecDissect. The span-stack thread-local is
# only initialized on the example thread; reading a `let` elsewhere (e.g. a
# Capybara server thread) previously raised `NoMethodError: undefined method
# 'last' for nil`.
describe "Something" do
  let(:value) { 42 }

  it "reads a let from another thread" do
    result = nil
    Thread.new { result = value }.join
    expect(result).to eq 42
  end
end
