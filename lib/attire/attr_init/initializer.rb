require_relative 'values_matcher'

module Attire
  module AttrInit
    class Initializer
      def initialize(arguments, after_initialize, opts = {})
        @values_matcher = opts[:values_matcher] || ValuesMatcher.new(arguments)
        @arity_range = arguments.arity_range
        @after_initialize = after_initialize
      end

      def instance_initialize(instance, values, value_block)
        arity_check(values)
        values_matcher.match(values, value_block).each do |k, v|
          instance.instance_variable_set("@#{k}", v)
        end
        instance.instance_exec(&after_initialize) if after_initialize
      end

      private

      attr_reader :values_matcher, :arity_range, :after_initialize

      def arity_check(values)
        return if arity_range.include?(values.length)
        fail ArgumentError, "wrong number of arguments (#{values.length} for #{arity_range})"
      end
    end
  end
end
