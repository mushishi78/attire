require 'attire/attr_init/initializer'

module Attire
	module AttrInit
	  describe Initializer do
	  	subject do
	  		Initializer.new(arguments, after_initialize, values_matcher: values_matcher)
	  	end
	  	let(:arguments) { double(arity_range: (1..3)) }
	  	let(:after_initialize) { -> { @foo *= 2 } }
	  	let(:values_matcher) { double(match: { foo: 3, bar: 'Yo' }) }
	  	let(:instance) { Class.new { attr_reader :foo, :bar }.new }

	  	it 'assigns ivars and runs after_initialize' do
	  		subject.instance_initialize(instance, [1], nil)
	  		expect(instance.foo).to eq(6)
	  		expect(instance.bar).to eq('Yo')
	  	end

	  	it 'does not accept to few arguments' do
				expect { subject.instance_initialize(instance, [], nil) }.to raise_error
	  	end

	  	it 'does not accept to many arguments' do
				expect { subject.instance_initialize(instance, [1, 5, 6, 8], nil) }.to raise_error
	  	end
	  end
	end
end
