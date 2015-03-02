require 'attire/attr_init/arguments'
require 'attire/attr_init/initializer'

module Attire
  module AttrInit
    class << self
      def apply(klass, args, after_initialize)
        arguments = Arguments.new(args)
        initializer = Initializer.new(arguments, after_initialize)
        define_initializer(klass, initializer)
        define_getters(klass, arguments)
      end

      private

      def define_initializer(klass, initializer)
        klass.send(:define_method, :initialize) do |*values, &value_block|
          initializer.instance_initialize(self, values, value_block)
        end
      end

      def define_getters(klass, arguments)
        names = arguments.getter_names
        names.each { |n| define_getter(klass, n, arguments.defaults[n]) }
        klass.send(:private, *names)
      end

      def define_getter(klass, name, default)
        klass.send(:define_method, name) do
          value = instance_variable_get("@#{name}")
          return value unless value.nil? && !default.nil?
          default = default.duplicable? ? default.dup : default
          instance_variable_set("@#{name}", default)
        end
      end
    end
  end
end
