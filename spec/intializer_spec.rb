require 'attire/initializer'

describe 'Initializer' do
  class Foo
    extend Attire::Initializer

    def initialize(foo, bar = 24, *args, dave: 82, phill:, **keys, &b)
      @bar = bar * 2
      @dave = dave / 2
    end
  end

  class Bar < Foo
    def initialize(jim)
    end
  end

  class Baz < Foo
    extend Attire::Initializer

    def initialize(jim)
    end
  end

  it 'sets instance variables, provides private getters and calls super' do
    a = Foo.new('raw', phill: 27)
    expect(a.send(:foo)).to eq('raw')
    expect(a.send(:phill)).to eq(27)
    expect(a.send(:bar)).to eq(48)
    expect(a.send(:args)).to eq([])
    expect(a.send(:dave)).to eq(41)
    expect(a.send(:keys)).to eq({})
    expect(a.send(:b)).to eq(nil)
  end

  it 'assigns optionals' do
    a = Foo.new('raw', -2, 'ding', 'showupp', dave: 38,
                                              phill: 392,
                                              harry: 200,
                                              norman: 50) do |x, y|
      x + y
    end
    expect(a.send(:foo)).to eq('raw')
    expect(a.send(:bar)).to eq(-4)
    expect(a.send(:args)).to eq(%w(ding showupp))
    expect(a.send(:dave)).to eq(19)
    expect(a.send(:phill)).to eq(392)
    expect(a.send(:keys)).to eq(harry: 200, norman: 50)
    expect(a.send(:b).call(2, 4)).to eq(6)
  end

  it 'does not prepend new initialize methods in inherited classes' do
    b = Bar.new(45)
    expect { b.send(:jim) }.to raise_error
  end

  it 'can be used in inherited classes by choice' do
    c = Baz.new(45)
    expect(c.send(:jim)).to eq(45)
  end
end
