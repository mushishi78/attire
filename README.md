# Attire

Convenience methods to remove some boiler plate in defining classes. Heavily inspired by [attr_extras](https://github.com/barsoom/attr_extras).

## Usage

### `attr_init :foo, :bar, fizz: 15, pop: nil`

Defines the following initializer:

``` ruby
def initializer(foo, bar, opts = {})
	@foo = foo
	@bar = bar
	@fizz = opts[:fizz] || 15
	@pop = opts[:pop]
end
```

`attr_init` can also accept a block which will be invoked after initialization.

### `attr_method :select, :bar`

Shortcut for:

``` ruby
attr_init :bar

def self.select(bar)
  new(bar).select
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

...

my_cheese = Roquefort.new
CheeseSpreader.spread(my_cheese) # CheeseError
```

### `attr_query :foo?`

Defines query methods like `foo?`, which is true if `foo` is truthy.

### `fattr_init :foo`

Calls `self.freeze` after initialization to make object immutable.

### `fattr_method :foo`

Same as `fattr_init`, only for `attr_method`.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attire'
```

And then execute:

  $ bundle

Or install it yourself as:

  $ gem install attire


## Contributing

1. Fork it ( https://github.com/[my-github-username]/attire/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
