require 'attire/attr_init'

module Attire
  def attr_query(*names)
    names.each do |name|
      name = name.to_s
      fail ArgumentError, "`#{name}?`, not `#{name}`." unless name.end_with?('?')
      define_method(name) { !!send(name.chop) }
    end
  end

  def attr_init(*names, &b)
    AttrInit.apply(self, names, b)
  end

  def attr_method(verb, *names, &b)
    define_singleton_method(verb) { |*a, &b| new(*a, &b).send(verb) }
    attr_init(*names, &b)
  end
end

class Module
  include Attire
end
