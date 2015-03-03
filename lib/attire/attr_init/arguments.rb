require 'attire/core_ext/duplicable'

module Attire
  module AttrInit
    class Arguments
      def initialize(arguments)
        @block = last_argument_with_prefix(arguments, '&')
        @splat = last_argument_with_prefix(arguments, '*')
        @names, @defaults = [], {}
        arguments.each { |arg| extract_argument(arg) }
        @arity_range = (min_arity..max_arity)
        @getters = (names.flatten + [splat, block]).compact
      end

      attr_reader :names, :splat, :block, :defaults, :arity_range, :getters

      private

      def last_argument_with_prefix(arguments, prefix)
        return unless arguments.last.to_s.start_with?(prefix)
        arguments.pop.to_s[1..-1]
      end

      def extract_argument(arg)
        return extract_hash(arg) if arg.is_a?(Hash)
        return extract_optional(arg) if arg.to_s.include?('=')
        extract_required(arg)
      end

      def extract_hash(hash)
        names << hash.keys
        defaults.merge!(hash)
      end

      def extract_optional(arg)
        name, default = arg.to_s.split('=').map(&:strip)
        names << name
        defaults[name] = eval(default)
      end

      def extract_required(arg)
        names << arg
        @min_arity = names.length
      end

      def min_arity
        @min_arity ||= 0
      end

      def max_arity
        splat ? Float::INFINITY : names.length
      end
    end
  end
end
