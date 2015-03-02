class Object
  def duplicable?
    true
  end
end

class NilClass
  def duplicable?
    false
  end
end

class FalseClass
  def duplicable?
    false
  end
end

class TrueClass
  def duplicable?
    false
  end
end

class Symbol
  def duplicable?
    false
  end
end

class Numeric
  def duplicable?
    false
  end
end

require 'bigdecimal'
class BigDecimal
  def duplicable?
    true
  end
end

class Method
  def duplicable?
    false
  end
end
