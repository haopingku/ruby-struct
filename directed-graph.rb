def dfs_traverse n, edges
  v, e = Array.new(n), Hash.new{[]}
  # v: nil = !visit, true: visit & in stack, false: visit & !in stack
  for i, j in edges
    e.key?(i) ? e[i].push(j) : (e[i] = [j])
  end

  i, q = 0, []
  while i < n || q.size > 0
    if q.size == 0
      if v[i] == nil
        q << i
      end
      i += 1
    else
      if v[j = q[-1]] == nil
        v[j] = true
        yield j, nil, e[j]
        q.concat(e[j])
      else
        j = q.pop
        if v[j]
          yield nil, j, e[j]
        end
        v[j] = false
      end
    end
  end
end

def topological_sort n, edges
  r = Array.new(n)
  dfs_traverse(n, edges) do |i, j|
    if j
      r[n -= 1] = j
    end
  end
  r
end

def is_cyclic? n, edges
  r = {}
  dfs_traverse(n, edges) do |i, j, e|
    if j
      if !e.all?{|k| r.key?(k)}
        return true
      end
      r[j] = 1
    end
  end
  false
end

def is_bipartite? n, edges
  r = {} # { node_id :: Integer => nil/true/false }
  # The edges here shouldn't be directed, add reverse edges.
  dfs_traverse(n, (edges + edges.map(&:reverse)).uniq) do |i, _, e|
    if i
      if r[i] == nil
        r[i] = true
      end
      for j in e
        if r[j] == r[i]
          return false
        end
        r[j] = !r[i]
      end
    end
  end
  true
end
