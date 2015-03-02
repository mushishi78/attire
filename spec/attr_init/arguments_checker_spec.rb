require 'attire/attr_init/arguments_checker'

module Attire
  module AttrInit
    describe ArgumentsChecker do
      subject { ArgumentsChecker }

      describe '#type_check' do
        it 'accepts Symbols, Strings and Hashes' do
          expect { subject.check(['foo', :bar, baz: 23]) }.to_not raise_error
        end

        it 'does not allow numbers' do
          expect { subject.check([78]) }.to raise_error
        end

        it 'does not allow arrays' do
          expect { subject.check([[:foo, 'bar']]) }.to raise_error
        end
      end

      describe '#block_check' do
        it 'accepts block as last argument' do
          expect { subject.check([:foo, :'&b']) }.to_not raise_error
        end

        it 'only allows blocks as last argument' do
          expect { subject.check([:'&b', :foo]) }.to raise_error
        end
      end

      describe '#splat_check' do
        it 'accepts splat as last argument' do
          expect { subject.check([:foo, :'*args']) }.to_not raise_error
        end

        it 'accepts splat as penultimate with block' do
          expect { subject.check([:'*args', :'&b']) }.to_not raise_error
        end

        it 'does not allow splat before anything other than block' do
          expect { subject.check([:'*args', :foo]) }.to raise_error
        end
      end

      describe '#required_after_optional_check' do
        it 'accepts if optionals are after requireds, with hashes whereever' do
          args = [:foo, { bar: 23 }, :fizz, :'bam = 23', { quiz: 'yo' }, :'*args', :'&b']
          expect { subject.check(args) }.to_not raise_error
        end

        it 'does not allow requireds after optionals' do
          args = [:foo, { bar: 23 }, :fizz, :'bam = 23', { quiz: 'yo' }, :danger, :'*args', :'&b']
          expect { subject.check(args) }.to raise_error
        end
      end
    end
  end
end
