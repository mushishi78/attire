module Attire
  def attire(param_str, method: :initialize, verb: nil, &after)
    names = eval("->(#{param_str}){}").parameters.map(&:last)
    def_init(param_str, method, names)
    add_getters(names)
    define_method(:__after) { instance_exec(&after) if after }
    def_verb(verb) if verb
  end

  private

  def def_init(param_str, method, names)
    class_eval "def #{method}(#{param_str})\n#{ivars(names)}\n__after\nend"
  end

  def ivars(names)
    names.map { |name| "@#{name} = #{name}\n" }.join
  end

  def add_getters(names)
    attr_reader(*names)
    private(*names)
  end

  def def_verb(verb)
    define_singleton_method(verb) { |*a, **k, &b| new(*a, **k, &b).send(verb) }
  end
end

class Module
  include Attire
end
