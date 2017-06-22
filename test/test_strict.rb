# frozen_string_literal: true

require "minitest/autorun"
require "dreck"

# Tests for strict checking.
class DreckStrictTest < Minitest::Test
  def test_unabsorbed_args
    # by default, failing to absorb all arguments raises an exception
    assert_raises Dreck::AbsorptionError do
      Dreck.parse %w[a b] do
        symbol :justone
      end
    end

    # with strictness disabled, some arguments just aren't captured
    r = Dreck.parse %w[a b], strict: false do
      symbol :first
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # the first argument is captured, and the results hash only has one pair
    assert_instance_of Symbol, r[:first]
    assert_equal :a, r[:first]
    assert_equal 1, r.results.size
  end

  def test_unfilled_args
    # by default, a dangling expected result raises an exception
    assert_raises Dreck::AbsorptionError do
      Dreck.parse ["a"] do
        symbol :first
        int :second
      end
    end

    # with strictness disabled, that dangling result is at the mercy of the parser
    assert_raises Dreck::ParserError do
      Dreck.parse ["a"], strict: false do
        symbol :first
        int :second
      end
    end

    r = Dreck.parse ["a"], strict: false do
      symbol :first
      # the string type is safe, since nil.to_s == ""
      string :second
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # the first argument is captured, while the second is a type-coerced nil
    assert_instance_of Symbol, r[:first]
    assert_instance_of String, r[:second]

    assert_equal :a, r[:first]
    assert_equal "", r[:second]
  end
end
