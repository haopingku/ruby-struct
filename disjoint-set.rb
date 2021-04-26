class DisjointSet
  def initialize n
    @a, @r = (0...n).to_a, Array.new(n, 0)
  end

  def union i, j
    x, y = find(i), find(j)
    if x != y
      if @r[x] < @r[y]
        @a[x] = y
      else
        @a[y] = x
        if @r[x] == @r[y]
          @r[x] += 1
        end
      end
    end
  end

  def find i
    @a[i] = @a[i] != i ? find(@a[i]) : @a[i]
  end
end
