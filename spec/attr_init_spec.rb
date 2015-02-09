describe '#attr_init' do
  let(:instance) { define_class(inside).new(1, 2, option1: 54) }
  let(:inside) do
    proc { attr_init :argument1, :argument2, option1: 23, option2: 'default', option3: nil }
  end

  it 'assigns arguments to private methods' do
    expect(instance.send(:argument1)).to eq(1)
    expect(instance.send(:argument2)).to eq(2)
    expect(instance.send(:option1)).to eq(54)
    expect(instance.send(:option2)).to eq('default')
    expect(instance.send(:option3)).to eq(nil)
  end

  context 'with optional hash missing' do
    let(:instance) { define_class(inside).new(1, 2) }

    it 'still assigns arguments to private methods using default' do
      expect(instance.send(:option1)).to eq(23)
    end
  end

  context 'with a non-nil falsy optional argument' do
    let(:instance) { define_class(inside).new(1, 2, option1: false) }

    it 'accepts argument' do
      expect(instance.send(:option1)).to eq(false)
    end
  end

  context 'with input of wrong type' do
    let(:inside) { proc { attr_init 'Strings bad' } }
    it { expect { define_class(inside) }.to raise_error(ArgumentError) }
  end

  context 'with too many arguments' do
    let(:instance) { define_class(inside).new(1, 2, {}, 4, 5) }
    it { expect { instance }.to raise_error(ArgumentError) }
  end

  context 'with too few arguments' do
    let(:instance) { define_class(inside).new(1) }
    it { expect { instance }.to raise_error(ArgumentError) }
  end

  context 'with after_initialize block' do
    let(:instance) { define_class(inside).new(1) }
    let(:inside) { proc { attr_init(:foo) { @foo = 5 } } }

    it 'calls block after initialize' do
      expect(instance.send(:foo)).to eq(5)
    end
  end

  context 'with splat' do
    let(:inside) { proc { attr_init :foo, :'*args' } }

    it 'collects args in splat' do
      expect(instance.send(:foo)).to eq(1)
      expect(instance.send(:args)).to eq([2, option1: 54])
    end

    context 'without splat args' do
      let(:instance) { define_class(inside).new(1) }

      it 'splat is empty' do
        expect(instance.send(:foo)).to eq(1)
        expect(instance.send(:args)).to eq([])
      end
    end
  end

  context 'with two splats' do
    let(:inside) { proc { attr_init :'*args1', :'*args2' } }
    it { expect { instance }.to raise_error(ArgumentError) }
  end

  context 'with block argument' do
    let(:inside) { proc { attr_init :foo, :'&block' } }
    let(:instance) { define_class(inside).new(1) { 'this is a block' } }

    it 'collects args in splat' do
      expect(instance.send(:foo)).to eq(1)
      expect(instance.send(:block).call).to eq('this is a block')
    end
  end

  context 'with two blocks' do
    let(:inside) { proc { attr_init :'&block1', :'&block2' } }
    it { expect { instance }.to raise_error(ArgumentError) }
  end

  context 'with hash, splat and block args and after_initialize block' do
    let(:inside) { proc { attr_init(:foo, { a: 4, b: 6 }, :'*args', :'&block') { @a -= 1 } } }

    context 'with only necessary arguments' do
      let(:instance) { define_class(inside).new(1) }

      it 'sets the rest to defaults, empty or nil respectively' do
        expect(instance.send(:foo)).to eq(1)
        expect(instance.send(:a)).to eq(3)
        expect(instance.send(:b)).to eq(6)
        expect(instance.send(:args)).to eq([])
        expect(instance.send(:block)).to eq(nil)
      end
    end

    context 'with all argument types' do
      let(:instance) { define_class(inside).new('foo', { a: 9 }, :fish, :candle) { 'block' } }

      it 'assigns arguments to private methods accordingly' do
        expect(instance.send(:foo)).to eq('foo')
        expect(instance.send(:a)).to eq(8)
        expect(instance.send(:b)).to eq(6)
        expect(instance.send(:args)).to eq([:fish, :candle])
        expect(instance.send(:block).call).to eq('block')
      end
    end
  end
end
