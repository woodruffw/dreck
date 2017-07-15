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
    # @param specified [Integer] the number of arguments specified
    # @param supplied [Integer] the number of arguments supplied
    def initialize(specified, supplied)
      nmany = specified < supplied ? "too many" : "too few"
      super "#{nmany} arguments given (#{supplied}, expected #{specified})"
    end
  end

  # Raised during argument absorption if a greedy list was expected but all arguments
  # have already been absorbed.
  class GreedyAbsorptionError < DreckError
    # @param specified [Integer] the number of arguments specified
    # @param supplied [Integer] the number of arguments supplied
    def initialize(specified, supplied)
      super "too few arguments given (#{specified}, expected >#{supplied})"
    end
  end

  # Raised during parsing if a given type cannot be produced from the corresponding
  # argument.
  class ParserError < DreckError
  end
end
