require 'attire/attr_init/arguments'

module Attire
	module AttrInit
	  describe Arguments do
	  	context 'with all argument types' do
		  	subject do
		  		Arguments.new([:foo, :'opts = {}', { h1: 23, h2: 'hey' }, :'*args', :'&b'])
		  	end

		  	it 'assigns names, splat, block, defaults and arity_range' do
		  		expect(subject.names).to eq([:foo, 'opts', [:h1, :h2]])
		  		expect(subject.splat).to eq('args')
		  		expect(subject.block).to eq('b')
		  		expect(subject.defaults).to eq('opts' => {}, h1: 23, h2: 'hey')
		  		expect(subject.arity_range).to eq(1..Float::INFINITY)
		  	end
		  end

	  	context 'without splat' do
		  	subject do
		  		Arguments.new([:foo, :'opts = {}', { h1: 23, h2: 'hey' }, :'&b'])
		  	end

		  	it 'assigns names, splat, block, defaults and arity_range' do
		  		expect(subject.arity_range).to eq(1..3)
		  	end
		  end
	  end
	end
end
