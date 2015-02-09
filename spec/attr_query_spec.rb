require 'attire'

describe '#attr_query' do
  subject { Class.new { attr_accessor :foo; attr_query :foo? }.new }

  it 'creates a query method' do
    expect(subject.foo?).to be(false)
    subject.foo = 'rah'
    expect(subject.foo?).to be(true)
  end

  it 'raises an exception without a tailing questionmark' do
    expect { Class.new { attr_query :foo } }.to raise_error
  end
end
