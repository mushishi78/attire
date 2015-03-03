module Attire
  module AttrInit
    class ArgumentsChecker
      def self.check(arguments)
        new.check(arguments)
      end

      def check(arguments)
        arguments.reverse.each_with_index do |arg, i|
          @arg, @i = arg, i
          type_check
          block_check
          splat_check
          required_after_optional_check
        end
      end

      private

      attr_reader :arg, :i

      TYPES = [Symbol, String, Hash]

      def type_check
        return if TYPES.include?(arg.class)
        fail ArgumentError, 'Must be Symbol, String or Hash.'
      end

      def block_check
        return unless block?
        fail ArgumentError, 'Block arguments must be last' unless i == 0
        @has_block = true
      end

      def splat_check
        return unless splat?
        return if i == (@has_block ? 1 : 0)
        fail ArgumentError, 'Splat arguments must come after ' \
                            'required and optional arguments'
      end

      def required_after_optional_check
        return if block? || splat? || hash?
        return @has_requireds = true unless optional?
        return unless @has_requireds
        fail ArgumentError, 'Required arguments must come before optional'
      end

      def block?
        arg.to_s.start_with?('&')
      end

      def splat?
        arg.to_s.start_with?('*')
      end

      def hash?
        arg.is_a?(Hash)
      end

      def optional?
        arg.to_s.include?('=')
      end
    end
  end
end
