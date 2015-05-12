# Attire

[![Build Status](https://travis-ci.org/mushishi78/attire.svg?branch=master)](https://travis-ci.org/mushishi78/attire)
[![Gem Version](https://badge.fury.io/rb/attire.svg)](http://badge.fury.io/rb/attire)

Helper to remove some boiler plate in defining classes.

## Usage

The `attire` method defines an `initialize` method where all it's parameters are stored as instance variables that can be retrieve with private getters. So a class defined like this:

```ruby
class Measurement
  def initialize(value:, units: :grams)
    @value = value
    @units = units
  end

  def to_s
    "#{value} (#{units})"
  end

  private

  attr_reader :value, :units
end
```

Can be shortened to:

```ruby
require 'attire'

class Measurement
  attire 'value:, units: :grams'

  def to_s
    "#{value} (#{units})"
  end
end
```

### Method Objects

Sometimes it's useful for objects that are designed to do only a single task to have a class method that both initializes the object and executes the task. For this purpose, `attire` allows you to set the `verb` keyword like so:

``` ruby
class CheeseSpreader
  attire 'cheese, cracker: Jacobs.new', verb: :spread

  def spread
    cracker.spreads << cheese
    cracker
  end
end

CheeseSpreader.spread(:roquefort)
```

## Installation

Add to Gemfile:

```ruby
gem 'attire'
```

## Inspirations

* [attr_extras](https://github.com/barsoom/attr_extras).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/attire/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
