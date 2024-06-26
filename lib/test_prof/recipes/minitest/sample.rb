# frozen_string_literal: true

module TestProf
  # Add ability to run only a specified number of example groups (randomly selected)
  module MinitestSample
    # Do not add these classes to resulted sample
    CORE_RUNNABLES = [
      Minitest::Test,
      defined?(Minitest::Unit::TestCase) ? Minitest::Unit::TestCase : nil,
      defined?(Minitest::Spec) ? Minitest::Spec : nil
    ].compact.freeze

    class << self
      def suites
        # Make sure that sample contains only _real_ suites
        Minitest::Runnable.runnables
          .select do |suite|
            CORE_RUNNABLES.any? { |kl| suite < kl } && suite.runnable_methods.any?
          end
      end

      def sample_groups(sample_size)
        saved_suites = suites
        Minitest::Runnable.reset
        saved_suites.sample(sample_size).each { |r| Minitest::Runnable.runnables << r }
      end

      def sample_examples(sample_size)
        all_examples = suites.flat_map do |runnable|
          runnable.runnable_methods.map { |method| [runnable, method] }
        end

        sample = all_examples.sample(sample_size).group_by(&:first)
        sample.transform_values! { |v| v.map(&:last) }

        # Filter examples by overriding #runnable_methods for all suites
        suites.each do |runnable|
          if sample.key?(runnable)
            runnable.define_singleton_method(:runnable_methods) do
              super() & sample[runnable]
            end
          else
            runnable.define_singleton_method(:runnable_methods) { [] }
          end
        end
      end

      def call
        if ENV["SAMPLE"]
          ::TestProf::MinitestSample.sample_examples(ENV["SAMPLE"].to_i)
        elsif ENV["SAMPLE_GROUPS"]
          ::TestProf::MinitestSample.sample_groups(ENV["SAMPLE_GROUPS"].to_i)
        end
      end
    end
  end
end
