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
