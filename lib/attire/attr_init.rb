require 'attire/attr_init/arguments'
require 'attire/attr_init/values_matcher'
require 'attire/attr_init/instance_methods'

module Attire
  module AttrInit
    def self.new(args, after_block)
      arguments = Arguments.new(args, after_block)
      getters, defaults = arguments.getter_names, arguments.defaults

      Module.new do
        define_singleton_method(:included) do |base|
          base.send(:include, InstanceMethods)
          base.extend ClassMethods
          base._arguments = arguments
        end

        getters.each { |n| define_method(n) { _get_attribute(n, defaults[n]) } }
        private *getters
      end
    end

    module ClassMethods
      attr_accessor :_arguments

      def inherited(child)
        super
        child._arguments = _arguments
      end
    end
  end
end
