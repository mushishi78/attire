require 'attire/attr_init/arguments_checker'
require 'attire/attr_init/arguments'
require 'attire/attr_init/values_matcher'
require 'attire/attr_init/instance_methods'

module Attire
  module AttrInit
    def self.new(args, after_block)
      ArgumentsChecker.check(args)
      arguments = Arguments.new(args)
      values_matcher = ValuesMatcher.new(arguments)
      getters, defaults = arguments.getters, arguments.defaults

      Module.new do
        include InstanceMethods
        define_method(:_arguments) { arguments }
        define_method(:_after_block) { after_block }
        define_method(:_values_matcher) { values_matcher }
        getters.each { |n| define_method(n) { _get_attribute(n, defaults[n]) } }
        private(*getters)
      end
    end
  end
end
