module Attire
	class Initializer
		def initialize(names, splat_name, block_name, after_initialize)
			@names = names
			@splat_name = splat_name
			@block_name = block_name
			@after_initialize = after_initialize
		end

		def instance_initialize(instance, values, value_block)
      @instance, @values, @value_block = instance, values, value_block
      arity_check
      set_ivars
      instance.instance_eval(&after_initialize) if after_initialize
    end

    private

    attr_reader :names, :splat_name, :block_name, :after_initialize,
    						:instance, :values, :value_block

    def set_ivars
      names.zip(values).each do |name, value|
        name.is_a?(Symbol) ? set_ivar(name, value) : set_hash(name, value)
      end
      set_splat
      set_block
    end

    def set_hash(defaults, values)
      values ||= {}
      hash_check(values)
      defaults.each { |name, default| set_ivar(name, values[name] || default) }
    end

    def set_splat
      return unless splat_name
      value_splat = values[names.length..values.length] || []
      set_ivar(splat_name, value_splat)
    end

    def set_block
      set_ivar(block_name, value_block) if block_name
    end

    def set_ivar(name, value)
      instance.instance_variable_set("@#{name}", value)
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
      names.last.is_a?(Hash) ? names.length - 1 : names.length
    end

    def max_arity
      splat_name ? Float::INFINITY : names.length
    end

    def arity_range
      @arity_range ||= (min_arity..max_arity)
    end
	end
end
