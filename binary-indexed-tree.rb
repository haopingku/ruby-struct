class BinaryIndexedTree
  def initialize a
    case a
    when Integer
      @a = Array.new(a + 1, 0)
    when Array
      @a = Array.new(a.size + 1, 0)
      for i in 0 ... @a.size
        add(i, a[i])
      end
    else
      raise(ArgumentError, 'Need to be either a number or an array.')
    end
  end

  def add i, v
    i += 1
    while i < @a.size
      @a[i] += v
      i += (i & (-i))
    end
  end

  def sum i
    r, i = 0, i + 1
    while i > 0
      r += @a[i]
      i -= (i & (-i))
    end
    r
  end
end
