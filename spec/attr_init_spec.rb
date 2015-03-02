require 'attire'

describe '#attr_init' do
  describe 'input types' do
    it 'accepts Symbols, Strings and Hashes' do
      expect { Class.new { attr_init 'foo', :bar,  baz: 23  } }.to_not raise_error
    end

    it 'does not allow numbers' do
      expect { Class.new { attr_init 78 } }.to raise_error
    end

    it 'does not allow arrays' do
      expect { Class.new { attr_init [23, 45] } }.to raise_error
    end
  end

  describe 'required arguments' do
    subject { Class.new { attr_init :foo, :bar } }

    it 'assigns arguments and provides private getters' do
      instance = subject.new(1, 4)
      expect(instance.send(:foo)).to eq(1)
      expect(instance.send(:bar)).to eq(4)
    end

    it 'raise exception for missing arguments' do
      expect { subject.new(3) }.to raise_error
    end

    it 'raise exception for too many arguments' do
      expect { subject.new(3, 34, 132) }.to raise_error
    end
  end

  describe 'optional arguments' do
    subject { Class.new { attr_init :'foo = 13' } }

    it 'assigns default if argument missing' do
      instance = subject.new
      expect(instance.send(:foo)).to eq(13)
    end

    it 'assigns value if argument present' do
      instance = subject.new(18)
      expect(instance.send(:foo)).to eq(18)
    end

    it 'handles a non-nil falsy optional argument' do
      instance = subject.new(false)
      expect(instance.send(:foo)).to eq(false)
    end

    context 'with optional argument before required argument' do
      subject { Class.new { attr_init :'foo = 13', :bar } }
      it { expect { subject }.to raise_error }
    end

    context 'with a sub-class that overrides default' do
      let(:sub_class) do
        Class.new(subject) do
          def foo
            @foo ||= 45
          end
        end
      end

      it 'assigns new default if argument missing' do
        instance = sub_class.new
        expect(instance.send(:foo)).to eq(45)
      end

      it 'assigns value if argument present' do
        instance = sub_class.new(18)
        expect(instance.send(:foo)).to eq(18)
      end
    end
  end

  describe 'hash' do
    subject { Class.new { attr_init :foo, bar: 23 } }

    it 'assigns default if argument missing' do
      instance = subject.new(1)
      expect(instance.send(:foo)).to eq(1)
      expect(instance.send(:bar)).to eq(23)
    end

    it 'assigns value if argument present' do
      instance = subject.new(1, bar: 9)
      expect(instance.send(:foo)).to eq(1)
      expect(instance.send(:bar)).to eq(9)
    end

    it 'handles a non-nil falsy optional argument' do
      instance = subject.new(1, bar: false)
      expect(instance.send(:foo)).to eq(1)
      expect(instance.send(:bar)).to eq(false)
    end

    context 'with mutable default' do
      subject { Class.new { attr_init foo: []; public :foo } }

      it 'creates a dup of default' do
        instance1 = subject.new
        instance2 = subject.new
        expect(instance1.foo).to_not be(instance2.foo)
      end
    end

    context 'with a sub-class that overrides default' do
      let(:sub_class) do
        Class.new(subject) do
          def bar
            @bar ||= 45
          end
        end
      end

      it 'assigns new default if argument missing' do
        instance = sub_class.new(1)
        expect(instance.send(:bar)).to eq(45)
      end

      it 'assigns value if argument present' do
        instance = sub_class.new(1, bar: 18)
        expect(instance.send(:bar)).to eq(18)
      end
    end
  end

  describe 'after_initialize block' do
    subject { Class.new { attr_init(:foo) { @foo += 5 } } }

    it 'calls block after initialization' do
      instance = subject.new(2)
      expect(instance.send(:foo)).to eq(7)
    end
  end

  describe 'splat' do
    subject { Class.new { attr_init :foo, :'*args' } }

    it 'assigns excess arguments to splat' do
      instance = subject.new(5, 2, 1, 43, 'hello', :bat)
      expect(instance.send(:foo)).to eq(5)
      expect(instance.send(:args)).to eq([2, 1, 43, 'hello', :bat])
    end

    it 'assigns an empty array if arguments missings' do
      instance = subject.new(56)
      expect(instance.send(:foo)).to eq(56)
      expect(instance.send(:args)).to eq([])
    end

    context 'with splat before required argument' do
      subject { Class.new { attr_init :'*args', :foo } }
      it { expect { subject }.to raise_error }
    end

    context 'with splat before optional argument' do
      subject { Class.new { attr_init :'*args', :'foo = 34' } }
      it { expect { subject }.to raise_error }
    end

    context 'with splat before hash' do
      subject { Class.new { attr_init :'*args', foo: 34 } }
      it { expect { subject }.to raise_error }
    end

    context 'with two splats' do
      subject { Class.new { attr_init :'*args1', :'*args2' } }
      it { expect { subject }.to raise_error }
    end
  end

  describe 'block' do
    subject { Class.new { attr_init :'&block' } }

    it 'assigns block and provides getter' do
      instance = subject.new { 'this is a block' }
      expect(instance.send(:block).call).to eq('this is a block')
    end

    context 'with block before required argument' do
      subject { Class.new { attr_init :'&block', :foo } }
      it { expect { subject }.to raise_error }
    end

    context 'with block before optional argument' do
      subject { Class.new { attr_init :'&block', :'foo = 34' } }
      it { expect { subject }.to raise_error }
    end

    context 'with block before hash' do
      subject { Class.new { attr_init :'&block', foo: 34 } }
      it { expect { subject }.to raise_error }
    end

    context 'with block before splat' do
      subject { Class.new { attr_init :'&block', :'*args' } }
      it { expect { subject }.to raise_error }
    end

    context 'with two blocks' do
      subject { Class.new { attr_init :'&block1', :'&block2' } }
      it { expect { subject }.to raise_error }
    end
  end

  describe 'integration' do
    subject do
      Class.new do
        attr_init(:foo, { a: 4, b: 6 }, :'*args', :'&block') { @a = a - 1 }
      end
    end

    it 'assigns defaults with only required arguments' do
      instance = subject.new(1)
      expect(instance.send(:foo)).to eq(1)
      expect(instance.send(:a)).to eq(3)
      expect(instance.send(:b)).to eq(6)
      expect(instance.send(:args)).to eq([])
      expect(instance.send(:block)).to eq(nil)
    end

    it 'assigns arguments when given' do
      instance = subject.new('foo', { a: 9 }, :fish, :candle) { 'block' }
      expect(instance.send(:foo)).to eq('foo')
      expect(instance.send(:a)).to eq(8)
      expect(instance.send(:b)).to eq(6)
      expect(instance.send(:args)).to eq([:fish, :candle])
      expect(instance.send(:block).call).to eq('block')
    end
  end
end
