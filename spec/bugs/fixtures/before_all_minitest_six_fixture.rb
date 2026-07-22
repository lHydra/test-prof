# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../../../../lib", __FILE__)
require_relative "../../support/ar_models"
require_relative "../../support/transactional_minitest"
require "minitest/autorun"
Minitest.load :test_prof if Minitest.respond_to?(:load)

require "test_prof/recipes/minitest/before_all"

class BeforeAllCountTest < Minitest::Test
  include TestProf::BeforeAll::Minitest

  @@runs = 0
  before_all { @@runs += 1 }

  def test_a
    puts "before_all ran #{@@runs} time(s)"
    assert true
  end

  def test_b
    puts "before_all ran #{@@runs} time(s)"
    assert true
  end

  def test_c
    puts "before_all ran #{@@runs} time(s)"
    assert true
  end
end

class ParallelBeforeAllCleanupTest < Minitest::Test
  def test_deactivates_the_previous_parallelized_class
    first_test = build_parallelized_test
    second_test = build_parallelized_test

    first_result = run_test_case(first_test)
    assert_predicate first_result, :passed?
    assert_predicate first_test.before_all_executor, :active?

    second_result = run_test_case(second_test)
    assert_predicate second_result, :passed?
    refute_predicate first_test.before_all_executor, :active?
    assert_predicate second_test.before_all_executor, :active?
  ensure
    first_test&.before_all_executor&.deactivate!
    second_test&.before_all_executor&.deactivate!
  end

  private

  def run_test_case(klass)
    if Minitest::Runnable.respond_to?(:run_suite)
      klass.new(:run_manually).run
    else
      Minitest.run_one_method(klass, :run_manually)
    end
  end

  def build_parallelized_test
    Class.new(Minitest::Test) do
      include TestProf::BeforeAll::Minitest

      self.parallelized = true

      before_all {}

      def run_manually
        assert true
      end
    end
  end
end
