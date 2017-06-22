dreck
=====

[![Gem Version](https://badge.fury.io/rb/dreck.svg)](https://badge.fury.io/rb/dreck)

A stupid parser for trailing arguments.

### Motivation

There are lots of good argument parsers for Ruby:
[OptionParser](https://ruby-doc.org/stdlib/libdoc/optparse/rdoc/OptionParser.html),
[Slop](https://github.com/leejarvis/slop), [trollop](https://manageiq.github.io/trollop/),
[cocaine](https://github.com/thoughtbot/cocaine), etc.

Most of these are great for parsing and typechecking options, but none provide a good
interface to the arguments that often *trail* the options.

Dreck does exactly that. Give it a specification of arguments (and their
types) to expect, and it will give you a nicely typechecked result.

### Installation

```bash
$ gem install dreck
```

### Usage

Dreck is best used in conjunction with an option parser like
[Slop](https://github.com/leejarvis/slop), which can provide an array of
arguments with options already filtered out:

```ruby
opts = Slop.parse do |s|
  # ...
end

opts.args # => [ "/dev/urandom", "/dev/sda", "512" ]

results = Dreck.parse opts.args, strict: true do
  file   :input
  symbol :output
  int    :blocksize
end

results[:input] # => "/dev/urandom"
results[:output] # => :"/dev/sda"
results[:blocksize] # => 512
```

Lists are also supported:

```ruby
result = Dreck.parse opts.args do
  string :uuid
  list   :file, :inputs, count: 2
  list   :int, :nums
end

result[:uuid] # => "01aa84ab-5b2c-4861-adc9-fcc6990a5ca5"
result[:inputs] # => ["/tmp/foo", "/tmp/bar"]
result[:nums] # => [1, 2, 3, 4, 5]
```

### TODO

* Guarding against multiple unbound lists/unbound list before scalar types
* Custom types?
