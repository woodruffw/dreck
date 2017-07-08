# frozen_string_literal: true

require "minitest/autorun"
require "dreck"

class DreckListTest < Minitest::Test
  # Tests for list results.
  def test_list_absorb_empty
    # parsing an empty list into a greedy list throws a greedy absorption error
    assert_raises Dreck::GreedyAbsorptionError do
      Dreck.parse [] do
        list :string, :stuff
      end
    end

    assert_raises Dreck::GreedyAbsorptionError do
      Dreck.parse [1, 2, 3] do
        int :x
        int :y
        int :z
        list :int, :foo
      end
    end
  end

  def test_list_absorb_all
    r = Dreck.parse %w[foo bar baz quux] do
      list :string, :names
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # the result is an array, and every element of that array is a string
    assert_instance_of Array, r[:names]
    r[:names].each { |n| assert_instance_of String, n }

    # every argument is absorbed
    assert_equal 4, r[:names].size
  end

  def test_list_absorb_tail
    r = Dreck.parse %w[foo 1 2 3] do
      symbol :first
      list :int, :nums
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # the result is one symbol, and an array of ints
    assert_instance_of Symbol, r[:first]
    assert_instance_of Array, r[:nums]
    r[:nums].each { |n| assert_instance_of Integer, n }

    # every trailing argument is absorbed
    assert_equal 3, r[:nums].size
  end

  def test_list_absorb_partial
    args = %w[3.14 2.71 / /etc /etc/hostname /etc/hosts foo bar baz]

    # each list parses correctly
    r = Dreck.parse args do
      list :float, :irrationals, count: 2
      list :directory, :dirs, count: 2
      list :file, :files, count: 2
      list :symbol, :stuff
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # each named result has the expected number of arguments and expected type
    r[:irrationals].each { |n| assert_instance_of Float, n }
    r[:dirs].each { |n| assert_instance_of String, n }
    r[:files].each { |n| assert_instance_of String, n }
    r[:stuff].each { |n| assert_instance_of Symbol, n }

    assert_equal 2, r[:irrationals].size
    assert_equal 2, r[:dirs].size
    assert_equal 2, r[:files].size
    assert_equal 3, r[:stuff].size
  end
end
