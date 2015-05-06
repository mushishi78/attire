require_relative 'initializer'

module Attire
  module MethodObject
    def self.new(verb)
      Module.new do
        define_singleton_method(:extended) { |base| base.extend Initializer }
        define_method(verb) { |*a, **k, &b| new(*a, **k, &b).send(verb) }
      end
    end
  end
end
