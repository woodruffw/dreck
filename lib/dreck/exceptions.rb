# frozen_string_literal: true

module Dreck
  # A generic error class for all {Dreck} errors.
  class DreckError < RuntimeError
  end

  # Raised during argument absorption if arguments are either left over
  # or are insufficient to populate the expected results.
  class AbsorptionError < DreckError
    # @param actual [Integer] the actual number of arguments given
    # @param expected [Integer] the expected number of arguments
    # @param greedy [Boolean] whether or not a list that absorbs the tail is present
    def initialize(actual, expected, greedy = false)
      nmany = actual > expected ? "too few" : "too many"
      act = greedy ? expected : actual
      exp = greedy ? ">=#{actual}" : expected
      super "#{nmany} arguments given (#{act}, expected #{exp})"
    end
  end

  # Raised during parsing if a given type cannot be produced from the corresponding
  # argument.
  class ParserError < DreckError
  end
end
