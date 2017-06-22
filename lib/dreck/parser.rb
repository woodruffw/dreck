# frozen_string_literal: true

module Dreck
  # Type and other constraint testing methods for {Dreck}.
  class Parser
    # @return [Array<Symbol>] the scalar types recognized by {Dreck}.
    # @api private
    SCALAR_TYPES = %i[int float path file directory symbol string].freeze

    class << self
      # @param int [String] the string to coerce into an integer
      # @return [Integer] the integer value of the string
      # @raise [ParserError] if the string cannot be converted
      def parse_int(int)
        Integer int rescue raise ParserError, "#{int}: not an integer"
      end

      # @param float [String] the string to coerce into a float
      # @return [Float] the floating-point value of the string
      # @raise [ParserError] if the string cannot be converted
      def parse_float(float)
        Float float rescue raise ParserError, "#{float}: not a float"
      end

      # @param path [String] the string to check for path-ness
      # @return [String] the string itself, if it is a path
      # @raise [ParserError] if the string is not a valid path on disk
      def parse_path(path)
        raise ParserError, "#{path}: no such path" unless File.exist?(path)
        path
      end

      # @param file [String] the string to check for file-ness
      # @return [String] the string itself, if it is a filename
      # @raise [ParserError] if the string is not a valid regular file on disk
      def parse_file(file)
        raise ParserError, "#{file}: no such file" unless File.file?(file)
        file
      end

      # @param dir [String] the string to check for directory-ness
      # @return [String] the string itself, if it is a directory
      # @raise [ParserError] if the string is not a valid directory on disk
      def parse_directory(dir)
        raise ParserError, "#{dir}: no such directory" unless File.directory?(dir)
        dir
      end

      # @param sym [String] the string to coerce into a symbol
      # @return [Symbol] the coerced symbol
      def parse_symbol(sym)
        sym.to_sym
      end

      # @param str [String] the string to coerce into a string
      # @return [String] the coerced string
      # @note This does nothing.
      def parse_string(str)
        str.to_s
      end

      # @param type [Symbol] the type of each member of the list
      # @param list [Array<String>] the value of each member
      # @return [Array<Object>] the coerced results
      def parse_list(type, list)
        list.map { |arg| send "parse_#{type}", arg }
      end
    end
  end
end
