describe '#fattr_init' do
  let(:instance) { define_class(inside).new(5) }
  let(:inside) { proc { fattr_init :chick } }

  it 'freezes class after initializing' do
    expect(instance.send(:chick)).to eq(5)
    expect { instance.instance_variable_set('@chick', 12) }.to raise_error
  end

  context 'with block' do
    let(:inside) { proc { fattr_init :chick do @chick = 15 end } }
    it 'still evaluates block' do
      expect(instance.send(:chick)).to eq(15)
    end
  end
end
