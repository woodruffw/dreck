# frozen_string_literal: true

module Dreck
  # A generic error class for all {Dreck} errors.
  class DreckError < RuntimeError
  end

  # Raised during argument absorption if arguments are either left over
  # or are insufficient to populate the expected results.
  class AbsorptionError < DreckError
    def initialize(actual, expected)
      nmany = actual > expected ? "too few" : "too many"
      super "#{nmany} arguments given (#{actual}, expected #{expected})"
    end
  end

  # Raised during parsing if a given type cannot be produced from the corresponding
  # argument.
  class ParserError < DreckError
  end
end
