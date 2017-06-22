# frozen_string_literal: true

require_relative "dreck/result"

# The primary namespace for {Dreck}.
module Dreck
  # {Dreck}'s current version.
  VERSION = "0.0.1"

  # Parse the given arguments and produce a result.
  # @param args [Array<String>] the arguments to parse
  # @param strict [Boolean] whether or not to be strict about argument absorption
  # @return [Result] the parsing result
  def self.parse(args = ARGV, strict: true, &block)
    result = Result.new(args, strict: strict)
    result.instance_eval(&block)
    result.parse!
  end
end
