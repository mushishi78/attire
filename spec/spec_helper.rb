require 'attire'

def define_class(proc)
  Class.new { instance_eval(&proc) }
end
