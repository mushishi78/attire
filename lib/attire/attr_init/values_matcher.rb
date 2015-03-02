require 'forwardable'

module Attire
  module AttrInit
    class ValuesMatcher
      extend Forwardable

      def initialize(arguments)
        @arguments = arguments
      end

      def match(values, value_block)
        @matched = {}
        names.zip(values) { |n, v| n.is_a?(Array) ? set_from_hash(v) : set(n, v) }
        set_splat(values)
        set_block(value_block)
        matched
      end

      private

      attr_reader :arguments, :matched
      def_delegators :arguments, :names, :splat, :block

      def set(name, value)
        matched[name] = value
      end

      def set_from_hash(values)
        matched.merge!(values || {})
      end

      def set_splat(values)
        matched[splat] = values[names.length..-1] || [] if splat
      end

      def set_block(value_block)
        matched[block] = value_block if block
      end
    end
  end
end
