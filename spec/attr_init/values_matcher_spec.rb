require 'attire/attr_init/values_matcher'

module Attire
  module AttrInit
    describe ValuesMatcher do
      subject { ValuesMatcher.new(arguments) }
      let(:arguments) { double(names: names, splat: 'args', block: 'b') }
      let(:names) { [:foo, 'opts', [:h1, :h2]] }
      let(:values) { [23, { o1: 'hey' }, { h2: 'sup' }, 56, 'box'] }
      let(:value_block) { -> { puts 'yo' } }

      it 'matches values to names' do
        matched = subject.match(values, value_block)
        expect(matched[:foo]).to eq(23)
        expect(matched['opts']).to eq(o1: 'hey')
        expect(matched[:h2]).to eq('sup')
        expect(matched['args']).to eq([56, 'box'])
        expect(matched['b']).to eq(value_block)
      end
    end
  end
end
