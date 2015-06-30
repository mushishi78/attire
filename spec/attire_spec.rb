require 'attire'

describe Attire do
  class Foo
    attire 'x, y'
  end

  class Bar
    attire("name: 'henry'") { @name = name.upcase }
  end

  class Multiplier
    attire 'a:, b: 35', verb: :multiply

    def multiply
      a * b
    end
  end

  class Adder
    attire 'a, b', verb: :add

    def add
      a + b
    end
  end

  it 'sets instance variables and provides getters' do
    f = Foo.new(38, 9)
    expect(f.send(:x)).to eq(38)
    expect(f.send(:y)).to eq(9)
  end

  it 'executes after block' do
    expect(Bar.new.send(:name)).to eq('HENRY')
  end

  it 'creates method objects with verb argument' do
    expect(Multiplier.multiply(a: 10)).to eq(350)
  end

  it 'does not pollute with helper methods' do
    helper_methods = :def_init, :ivars, :add_getters, :def_verb
    expect(Foo.private_methods).to_not include(*helper_methods)
  end

  it 'does not count empty keyword args as an argument' do
    expect(Adder.add(5, 8)).to eq(13)
  end
end
