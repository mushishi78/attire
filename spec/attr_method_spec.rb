require 'attire'

describe '#attr_method' do
  subject do
    Class.new do
      attr_method :select, :child, toy: 5

      def select
        toy * child
      end
    end
  end

  it 'creates a class method that initializes and calls instance method' do
    expect(subject.select(3)).to eq(15)
    expect(subject.select(3, toy: 2)).to eq(6)
  end
end
