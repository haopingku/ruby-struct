class SegmentTree
  def initialize n, init_val = 0, &merge
    @n, @z = n, 2 ** Math.log2(n).ceil
    @merge = merge || ->(i, j){ i + j }
    @a = Array.new(2 * @z - 1, init_val)
  end

  def update i, v
    if !(0 <= i && i < @n)
      raise(ArgumentError, "not in (0...#{@n}), got #{i}.")
    end

    @a[i += @z - 1] = v
    while i > 0
      pi = (i - 1) / 2
      @a[pi] = @merge.(@a[2 * pi + 1], @a[2 * pi + 2])
      i = pi
    end
  end

  def query q
    if !q.is_a?(Range)
      raise(TypeError, "not an instance of Range, got #{q}.")
    end

    query_i(0, @z - 1, @z, q.begin + @z - 1, q.size)
  end

  private def query_i i, si, sz, qi, qz
    if sz == 0
      nil
    elsif qi <= si && si + sz <= qi + qz
      @a[i]
    else
      r1 = query_i(2 * i + 1, si, sz / 2, qi, qz)
      r2 = query_i(2 * i + 2, si + sz / 2, sz / 2, qi, qz)
      (r1 && r2) ? @merge.(r1, r2) : (r1 || r2)
    end
  end
end
