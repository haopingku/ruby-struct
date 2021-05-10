class SegmentTree
  def initialize n, init_val = 0, &merge
    @n, @z, @a = n, 1, Array.new(4 * n, init_val)
    @merge = merge || ->(i, j){ i + j }
    while @z < n; @z *= 2; end
  end

  def update i, v
    @a[i += @z - 1] = v
    while i > 0
      pi = (i - 1) / 2
      @a[pi] = @merge.(@a[2 * pi + 1], @a[2 * pi + 2])
      i = pi
    end
  end

  def query q
    query_i(0, @z - 1, @z, q.begin + @z - 1, q.size)
  end

  private def query_i i, si, sz, qi, qz
    if sz == 0 || qz == 0
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
