require 'attire/initializer'

module Attire
  class AttrInit
    def self.apply(*args)
      new(*args).apply
    end

    def initialize(klass, names, after_initialize)
      @klass, @names, @after_initialize = klass, names, after_initialize
    end

    def apply
      type_check
      extract_splat_and_block_names
      optional_arguments_check
      instance_initialize = initializer.method(:instance_initialize)

      klass.send(:define_method, :initialize) do |*values, &value_block|
        instance_initialize.call(self, values, value_block)
      end

      define_getters
    end

    private

    attr_reader :klass, :names, :splat_name, :block_name, :after_initialize

    def type_check
      return if names.all? { |n| [Symbol, String, Hash].include?(n.class) }
      fail ArgumentError, 'Must be Symbol, String or Hash.'
    end

    def extract_splat_and_block_names
      @block_name = last_name_with_prefix('&')
      @splat_name = last_name_with_prefix('*')
      excess_splat_and_block_names_check
    end

    def initializer
      Initializer.new(names, splat_name, block_name, after_initialize)
    end

    def define_getters
      getter_names.each do |name|
        klass.send(:define_method, name) { instance_variable_get("@#{name}") }
      end
      klass.send(:private, *getter_names)
    end

    def getter_names
      getter_names = names.map do |arg|
        next arg.keys if arg.respond_to?(:keys)
        next optional_name(arg) if optional?(arg)
        arg
      end
      getter_names += [splat_name, block_name]
      getter_names.flatten.compact
    end

    def last_name_with_prefix(prefix)
      without_prefix(names.pop) if last_name_prefix?(prefix)
    end

    def without_prefix(symbol)
      symbol.to_s[1..-1].to_sym
    end

    def last_name_prefix?(prefix)
      names.last.to_s.start_with?(prefix)
    end

    def excess_splat_and_block_names_check
      return if names.none? { |n| n.to_s.start_with?('&', '*') }
      fail ArgumentError, 'Splat and Block arguments must be last'
    end

    def optional_arguments_check
      start = names.find_index { |n| optional?(n) }
      return unless start
      return if names[start..-1].all? { |n| n.is_a?(Hash) || optional?(n) }
      fail ArgumentError, 'Required arguments must come before optional'
    end

    def optional?(name)
      name.to_s.include?('=')
    end

    def optional_name(name)
      name.to_s.split('=')[0].strip
    end
  end
end
