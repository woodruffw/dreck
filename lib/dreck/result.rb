# frozen_string_literal: true

require_relative "exceptions"
require_relative "parser"

module Dreck
  # Represents the state and results of a {Dreck} parse.
  class Result
    # @return [Array] the type, name, and count information for arguments
    attr_reader :expected

    # @return [Hash] the parsing results hash
    attr_reader :results

    # @param args [Array<String>] the arguments to parse
    # @param strict [Boolean] whether or not to be strict about argument absorption
    def initialize(args, strict: true)
      @args = args.dup
      @strict = strict
      @expected = []
      @results = {}
    end

    # @param key [Symbol] the named argument to look up
    # @return [Object] the parsed value
    def [](key)
      @results[key]
    end

    # @return [Boolean] whether the results were parsed strictly
    def strict?
      @strict
    end

    Parser::SCALAR_TYPES.each do |type|
      define_method type do |sym|
        @expected << [type, sym]
      end
    end

    # Specifies a list of arguments of a given type to be parsed.
    # @param type [Symbol] the type of the arguments
    # @param sym [Symbol] the name of the argument in {results}
    # @param count [Integer] the number of arguments in the list
    def list(type, sym, count: nil)
      @expected << [:list, type, sym, count]
    end

    # Perform the actual parsing.
    # @return [Result] this instance
    # @api private
    def parse!
      check_absorption!

      @expected.each do |type, *rest|
        case type
        when :list
          parse_list!(*rest)
        else
          parse_type!(type, *rest)
        end
      end

      self
    end

    # Check whether the expected arguments absorb all supplied arguments.
    # @raise [AbsoptionError] if absorption fails and {strict?} is not true
    # @api private
    def check_absorption!
      count = count_expected

      return if count.nil?
      raise AbsoptionError, "too few arguments" if count > @args.size && strict?
      raise AbsoptionError, "too many arguments" if count < @args.size && strict?
    end

    # Count the number of arguments expected to be supplied.
    # @raise [Integer, nil] the number of expected arguments, or nil if a list
    #  of indeterminate size is specified
    # @api private
    def count_expected
      @expected.inject(0) do |n, exp|
        case exp.first
        when :list
          # if the list is greedy, all arguments have to be absorbed
          break unless exp[3]

          n + exp[3]
        else
          n + 1
        end
      end
    end

    # Parse a one or more expected arguments of a given type and add them to
    #  the results.
    # @param type [Symbol] the type of the individual elements of the list
    # @param sym [Symbol] the key to store the results under in {results}
    # @param count [Integer, nil] the size of the list, or nil if the list
    #  absorbs all following arguments
    # @api private
    def parse_list!(type, sym, count)
      args = if count
               @args.shift count
             else
               @args
             end

      @results[sym] = Parser.parse_list type, args
    end

    # Parse one expected argument of a given scalar type and add it to the results.
    # @param type [Symbol] the type of the expected argument
    # @param sym [Symbol] the key to store the result under in {results}
    # @api private
    def parse_type!(type, sym)
      arg = @args.shift

      @results[sym] = Parser.send("parse_#{type}", arg)
    end
  end
end
