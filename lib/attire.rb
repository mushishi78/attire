require 'attire/attr_init'

module Attire
  def attr_query(*names)
    names.each do |name|
      name = name.to_s
      fail ArgumentError, "`#{name}?`, not `#{name}`." unless name.end_with?('?')
      define_method(name) { !!send(name.chop) }
    end
  end

  def attr_init(*args, &b)
    AttrInit.apply(self, args, b)
  end

  def attr_method(verb, *args, &b)
    define_singleton_method(verb) { |*a| new(*a).send(verb) }
    attr_init(*args, &b)
  end
end

class Module
  include Attire
end
