module Attire
  class << self
    def attire(base, param_str, method: :initialize, verb: nil, &after)
      names = eval("->(#{param_str}){}").parameters.map(&:last)
      def_init(base, param_str, method, names)
      add_getters(base, names)
      base.send(:define_method, :__after) { instance_exec(&after) if after }
      def_verb(base, verb) if verb
    end

    private

    def def_init(base, param_str, method, names)
      base.class_eval "def #{method}(#{param_str})\n#{ivars(names)}\n__after\nend"
    end

    def ivars(names)
      names.map { |name| "@#{name} = #{name}\n" }.join
    end

    def add_getters(base, names)
      base.send(:attr_reader, *names)
      base.send(:private, *names)
    end

    def def_verb(base, verb)
      base.define_singleton_method(verb) { |*a, &b| new(*a, &b).send(verb) }
    end
  end
end

class Module
  def attire(*a, &b)
    Attire.attire(self, *a, &b)
  end
end
