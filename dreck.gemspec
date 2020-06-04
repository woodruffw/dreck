# frozen_string_literal: true

require_relative "lib/dreck"

Gem::Specification.new do |s|
  s.name                  = "dreck"
  s.version               = Dreck::VERSION
  s.summary               = "dreck - A stupid parser for trailing arguments."
  s.description           = "Typechecks and coerces non-option arguments."
  s.authors               = ["William Woodruff"]
  s.email                 = "william@tuffbizz.com"
  s.files                 = Dir["LICENSE", "*.md", ".yardopts", "lib/**/*"]
  s.required_ruby_version = ">= 2.3.0"
  s.homepage              = "https://github.com/woodruffw/dreck"
  s.license               = "Nonstandard"
end
