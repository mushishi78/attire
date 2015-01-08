describe '#attr_query' do
  context 'with correct arguments' do
    let(:instance) { define_class(inside).new }
    let(:inside) do
      proc { attr_accessor :foo; attr_query :foo? }
    end

    it 'creates a query method' do
      expect(instance.foo?).to be(false)
      instance.foo = 'rah'
      expect(instance.foo?).to be(true)
    end
  end

  context 'without a tailing questionmark' do
    let(:inside) { proc { attr_query :bar } }
    it { expect { define_class(inside) }.to raise_error }
  end
end
