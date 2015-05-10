require 'attire/initializer'
require 'contracts'

describe 'Initializer' do
  class Foo
    include Contracts
    extend Attire::Initializer

    Contract ({ foo: Num, bar: String }) => Any
    def initialize(foo:, bar:)
    end
  end

  it 'should use file location from original callback' do
    a = Foo.new(foo: 34, bar: 'yo')
    expect { a.send(:foo) }.to_not raise_error
  end

  it 'should still have contract apply to initialize' do
    expect { Foo.new(foo: 'yo') }.to raise_error
  end
end
