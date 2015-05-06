module Attire
  module Initializer
    def self.extended(base)
      base.class.instance_variable_set(:@_added, false)
    end

    def method_added(method_name)
      return super unless method_name == :initialize && !added?
      method = instance_method(:initialize)
      names = method.parameters.map(&:last)
      add_initialize(method, names)
      add_getters(names)
      self.added = true
      super
    end

    private

    def added?
      self.class.instance_variable_get(:@_added)
    end

    def added=(added)
      self.class.instance_variable_set(:@_added, added)
    end

    def add_initialize(method, names)
      initialize_line = initialize_line(method)
      set_ivars = names.map { |name| "@#{name} = #{name}\n" }.join

      initializer = Module.new do
        class_eval "#{initialize_line}#{set_ivars}super\nend\n"
      end
      prepend initializer
    end

    def initialize_line(method)
      file, endline = *method.source_location
      File.readlines(file)[0..endline].reverse.each do |line|
        return line if line.include?('initialize')
      end
    end

    def add_getters(names)
      attr_reader(*names)
      private(*names)
    end
  end
end
