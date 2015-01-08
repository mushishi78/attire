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

  context 'with block' do
    let(:instance) { define_class(inside).new(1) }
    let(:inside) { proc { attr_init(:foo) { @foo = 5 } } }

    it 'calls block' do
      expect(instance.send(:foo)).to eq(5)
    end
  end
end
