require 'attire/initializer'
require 'contracts'

describe 'Initializer' do
  class MyClass
    include Contracts
    extend Attire::Initializer

    Contract ({ foo: Num, bar: String }) => Any
    def initialize(foo:, bar:)
    end
  end

  it 'should use file location from original callback' do
    a = MyClass.new(foo: 34, bar: 'yo')
    expect { a.send(:foo) }.to_not raise_error
  end

  it 'should still have contract apply to initialize' do
    expect { MyClass.new(foo: 'yo', bar: 99) }.to raise_error(ParamContractError)
  end
end
