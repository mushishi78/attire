module Attire
  module AttrInit
    module InstanceMethods
      def initialize(*values, &value_block)
        _arity_check(values)
        _match(values, value_block).each { |k, v| instance_variable_set("@#{k}", v) }
        instance_exec(&_after_block) if _after_block
      end

      private

      def _arity_check(values)
        return if _arity_range.include?(values.length)
        fail ArgumentError, "wrong number of arguments "\
                            "(#{values.length} for #{_arity_range})"
      end

      def _get_attribute(name, default)
        value = instance_variable_get("@#{name}")
        return value unless value.nil? && !default.nil?
        instance_variable_set("@#{name}", _duped_default(default))
      end

      def _duped_default(default)
        default.duplicable? ? default.dup : default
      end

      def _match(*args)
        _values_matcher.match(*args)
      end

      def _arity_range
        _arguments.arity_range
      end
    end
  end
end
