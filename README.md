# Attire

[![Build Status](https://travis-ci.org/mushishi78/attire.svg?branch=master)](https://travis-ci.org/mushishi78/attire)
[![Gem Version](https://badge.fury.io/rb/attire.svg)](http://badge.fury.io/rb/attire)

Convenience methods to remove some boiler plate in defining classes. Inspired by [attr_extras](https://github.com/barsoom/attr_extras).

## Usage

### `attr_init :foo, :bar, fizz: 15, pop: nil`

Defines the following:

``` ruby
def initialize(foo, bar, opts = {})
	@foo = foo
	@bar = bar
	@fizz = opts[:fizz] || 15
	@pop = opts[:pop]
end

private

attr_reader :foo, :bar, :fizz, :pop
```

Optional, splat and blocks arguments can also be defined:

``` ruby
attr_init :'opts = {}', :'*args', :'&block'
```

If a block is provided, it will be evaluated after initialization:

``` ruby
attr_init :foo do
  @foo = foo ** 2
end
```

### `attr_method :select, :bar`

Defines the following:

``` ruby
attr_init :bar

def self.select(*args, &block)
  new(*args, &block).select
end
```

This is useful for method objects/use cases:

``` ruby
class CheeseSpreader
  attr_method :spread, :cheese, crackers: Jacobs.new

  def spread
    raise CheeseError unless cheese.is_a?(Cheddar)
    cheese.spread_on(crackers)
  end
end

CheeseSpreader.spread(Roquefort.new) # CheeseError
```

### `attr_query :foo?`

Defines query `foo?`, which is true if `foo` is truthy.

## Installation

Add to Gemfile:

```ruby
gem 'attire'
```

Require library:

``` ruby
require 'attire'
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/attire/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
