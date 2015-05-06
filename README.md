# Attire

[![Build Status](https://travis-ci.org/mushishi78/attire.svg?branch=master)](https://travis-ci.org/mushishi78/attire)
[![Gem Version](https://badge.fury.io/rb/attire.svg)](http://badge.fury.io/rb/attire)

Mixins to remove some boiler plate in defining classes.

**N.B. This is the README for version 2.0.0. Major changes have been made. For previous versions please consult the tagged commit.**

## Initializer

`Attire::Initializer` extends a subsequent initialize method so that all it's parameters are assigned to instance variables and they can all be reached from private getters. For example:

``` ruby
require 'attire'

class MyClass
  extend Attire::Initializer

  def initialize(foo:, bar: 24)
    @bar = bar * 2
  end

  def result
    foo + bar
  end
end

my_instance = MyClass.new(foo: 50)
my_instance.result # 98
```

## MethodObject

`Attire::MethodObject` does the same as `Attire::Initializer` but it also adds a singleton method that creates an instance and then calls an instance method. This is useful for objects that are designed to do one task. For example:

``` ruby
class CheeseSpreader
  extend Attire::MethodObject.new(:spread)

  def initialize(cheese, cracker: Jacobs.new)
  end

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
