require 'attire/method_object'

describe 'MethodObject' do
  class Multiplier
    extend Attire::MethodObject.new(:multiply)

    def initialize(a:, b: 35)
    end

    def multiply
      a * b
    end
  end

  it 'extends initializer and provides singleton method' do
    expect(Multiplier.multiply(a: 2)).to eq(70)
  end
end
