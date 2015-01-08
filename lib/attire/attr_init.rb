module Attire
  class AttrInit
    def self.apply(*args)
      new(*args).apply
    end

    def initialize(klass, args, block)
      @klass, @args, @block = klass, args, block
    end

    def apply
      type_check
      init = method(:init)
      klass.send(:define_method, :initialize) { |*values| init.call(self, values) }
      define_getters
    end

    private

    attr_reader :klass, :args, :block, :instance, :values

    def init(instance, values)
      @instance, @values = instance, values
      arity_check
      set_variables
      instance.instance_eval(&block) if block
    end

    def set_variables
      args.zip(values).each do |arg, value|
        next set_variable(arg, value) if arg.is_a?(Symbol)
        value = {} if value.nil?
        hash_check(value)
        arg.each { |k, v| set_variable(k, value[k] || v) }
      end
    end

    def define_getters
      getter_names.each do |arg|
        klass.send(:define_method, arg) { instance_variable_get("@#{arg}") }
        klass.send(:private, arg)
      end
    end

    def type_check
      return if args.all? {|a| [Symbol, Hash].include?(a.class) }
      fail ArgumentError, 'Must be Symbol or Hash.'
    end

    def arity_check
      return if arity_range.include?(values.length)
      fail ArgumentError, "wrong number of arguments (#{values.length} for #{arity_range})"
    end

    def hash_check(value)
      return if value.is_a?(Hash)
      fail ArgumentError, "#{value} should be Hash."
    end

    def min_arity
      args.last.is_a?(Hash) ? args.length - 1 : args.length
    end

    def arity_range
      @arity_range ||= (min_arity..args.length)
    end

    def set_variable(name, value)
      instance.instance_variable_set("@#{name}", value)
    end

    def getter_names
      args.map { |arg| arg.respond_to?(:keys) ? arg.keys : arg }.flatten
    end
  end
end
