describe '#attr_method' do
  let(:klass) do
    klass = Class.new do
      attr_method :select, :child, toy: 5

      def select
        toy * child
      end
    end
  end

  it 'creates a class method that initializes and calls instance method' do
    expect(klass.select(3)).to eq(15)
    expect(klass.select(3, toy: 2)).to eq(6)
  end
end
