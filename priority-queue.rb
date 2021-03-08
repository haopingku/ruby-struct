class PriorityQueue
  def initialize
    @a = [] # 0-indexed array
  end

  def size
    @a.size
  end

  def insert o
    @a.push(o)
    i = @a.size - 1
    while i > 0 && comp(i, j = (i - 1) / 2)
      i = swap(i, j)
    end
    self
  end
  alias << insert

  def top
    @a[0]
  end

  def pop
    if @a.size == 1
      @a.pop
    else
      r, i, @a[0] = @a[0], 0, @a.pop
      while i
        i = if (j = i * 2 + 1) < @a.size
          ji = comp(j, i)
          if (k = i * 2 + 2) < @a.size
            ki = comp(k, i)
            if ji
              ki ? (comp(j, k) ? swap(i, j) : swap(i, k)) : swap(i, j)
            else
              ki ? swap(i, k) : nil
            end
          else
            ji ? swap(i, j) : nil
          end
        end
      end
      r
    end
  end

  private def swap i, j
    @a[i], @a[j] = @a[j], @a[i]
    j
  end

  private def comp i, j
    (@a[i] <=> @a[j]) == -1
  end
end
