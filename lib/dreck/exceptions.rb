# frozen_string_literal: true

module Dreck
  # A generic error class for all {Dreck} errors.
  class DreckError < RuntimeError
  end

  # Raised during list specification if a non-positive number of arguments
  # are requested.
  class BadCountError < DreckError
  end

  # Raised during argument absorption if arguments are either left over
  # or are insufficient to populate the expected results.
  class AbsorptionError < DreckError
    # @param actual [Integer] the actual number of arguments given
    # @param expected [Integer] the expected number of arguments
    def initialize(actual, expected)
      nmany = actual < expected ? "too few" : "too many"
      super "#{nmany} arguments given (#{actual}, expected #{expected})"
    end
  end

  # Raised during argument absorption if a greedy list was expected but all arguments
  # have already been absorbed.
  class GreedyAbsorptionError < DreckError
    # @param actual [Integer] the actual number of arguments given
    # @param expected [Integer] the expected number of arguments
    def initialize(actual, expected)
      super "too few arguments given (#{actual}, expected >#{expected})"
    end
  end

  # Raised during parsing if a given type cannot be produced from the corresponding
  # argument.
  class ParserError < DreckError
  end
end
