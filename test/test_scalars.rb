# frozen_string_literal: true

require "minitest/autorun"
require "dreck"

# Tests for scalar results.
class DreckScalarsTest < Minitest::Test
  def test_parse_int
    r = Dreck.parse ["123"] do
      int :onetwothree
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # the type of the argument is an integer
    assert_instance_of Integer, r[:onetwothree]

    # the value of the integer is as expected
    assert_equal 123, r[:onetwothree]

    # trying to parse a non-integer string fails
    assert_raises Dreck::ParserError do
      Dreck.parse ["abc"] do
        int :thisshouldntwork
      end
    end
  end

  def test_parse_float
    r = Dreck.parse %w[3.14 10] do
      float :pi
      float :int2float
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # the type of the arguments is float
    assert_instance_of Float, r[:pi]
    assert_instance_of Float, r[:int2float]

    # the value of the floats is as expected, and the integer is correctly
    # promoted to a float
    assert_in_epsilon 3.14, r[:pi]
    assert_in_epsilon 10.0, r[:int2float]

    # trying to parse a non-float string fails
    assert_raises Dreck::ParserError do
      Dreck.parse ["abc"] do
        float :thisshouldntwork
      end
    end
  end

  def test_parse_path
    # path accepts both directories and files
    r = Dreck.parse %w[/ /etc/hostname] do
      path :root
      path :hostname
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # the type of the arguments is string
    assert_instance_of String, r[:root]
    assert_instance_of String, r[:hostname]

    # both paths exist on disk
    assert File.exist? r[:root]
    assert File.exist? r[:hostname]

    # trying to parse a nonexistent path fails
    assert_raises Dreck::ParserError do
      Dreck.parse ["/this/should/not/exist"] do
        path :badfile
      end
    end
  end

  def test_parse_file
    r = Dreck.parse ["/etc/hostname"] do
      file :hostname
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # the type of the argument is string
    assert_instance_of String, r[:hostname]

    # the file exists on disk, and is a regular file (not a directory or device)
    assert File.file? r[:hostname]
    refute File.directory? r[:hostname]
    assert_equal "file", File.ftype(r[:hostname])

    # trying to parse a nonexistent path fails
    assert_raises Dreck::ParserError do
      Dreck.parse ["/this/should/not/exist"] do
        file :badfile
      end
    end

    # trying to parse a directory fails
    assert_raises Dreck::ParserError do
      Dreck.parse ["/"] do
        file :badfile
      end
    end
  end

  def test_parse_directory
    r = Dreck.parse %w[/ /etc] do
      directory :root
      directory :etc
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # the type of the arguments is string
    assert_instance_of String, r[:root]
    assert_instance_of String, r[:etc]

    # the directories exist on disk
    assert File.directory? r[:root]
    assert File.directory? r[:etc]

    # trying to parse a nonexistent path fails
    assert_raises Dreck::ParserError do
      Dreck.parse ["/this/should/not/exist"] do
        directory :baddir
      end
    end

    # trying to parse a regular file fails
    assert_raises Dreck::ParserError do
      Dreck.parse ["/etc/hostname"] do
        directory :baddir
      end
    end
  end

  def test_parse_symbol
    r = Dreck.parse ["abc", "123", "that's how easy love can be"] do
      symbol :abc
      symbol :onetwothree
      symbol :jackson5
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # the type of the arguments is symbol
    assert_instance_of Symbol, r[:abc]
    assert_instance_of Symbol, r[:onetwothree]
    assert_instance_of Symbol, r[:jackson5]

    # the values of the symbols are as expected
    assert_equal :abc, r[:abc]
    assert_equal :"123", r[:onetwothree]
    assert_equal :"that's how easy love can be", r[:jackson5]
  end

  def test_parse_string
    r = Dreck.parse %w[foobar 10001] do
      string :string
      string :zip
    end

    # parsing returns a result
    assert_instance_of Dreck::Result, r

    # the type of the arguments is string
    assert_instance_of String, r[:string]
    assert_instance_of String, r[:zip]

    # the values of the strings are as expected
    assert_equal "foobar", r[:string]
    assert_equal "10001", r[:zip]
  end
end
