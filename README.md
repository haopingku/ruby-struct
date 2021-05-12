# Ruby Data Structure Library
A simple library of implementations of common data structures and algorithms
that are not in the built-in library.

## Binary Indexed Tree

- `#initialize(a)` to initialize. `a` can be an array or the size.
- `#add(index, value)` to add value to the `index`.
- `#sum(index)` to get the sum from index `0` to `index`.

### Example
Get sum from range `i` to `j` (include `j`).

```ruby
bit = BinaryIndexedTree.new([5, 1, 4, 2, 3])
i, j = ...
bit.sum(j) - (i > 0 ? bit.sum(i) : 0)
```

## Directed Graph
Methods for directed graphs. (`n` is the amount of vertices indexed from `0` to `n - 1`, `edges` is an array of direct edges e.g. `[[0,1],[1,2]]`.)

- `dfs_traverse(n, edges)` to DFS-traverse in a graph.
- `topological_sort(n, edges)` to get a valid topological order.
- `is_cyclic?(n, edges)` to detect if the graph is a cyclic graph.
- `is_bipartite?(n, edges)` to detect if the graph is [bipartite](https://en.wikipedia.org/wiki/Bipartite_graph).

## Disjoint Set
A disjoint set (aka union find) of N nodes.

- `#initialize(n)` to initialize a set with node id from `0` to `n - 1`.
- `#find(i)` to find the set index (integer) of node `i`.
- `#union(i, j)` to union two nodes.

### Example
Find groups of connected vertices in a graph.

```ruby
edges = [[0,1],[1,4],[2,5]]
ds = DisjointSet.new(6)
for i, j in edges
  ds.union(i, j)
end
p (0...6).group_by{|i| ds.find(i)}.values # [[0, 1, 4], [2, 5], [3]]
```

## Priority Queue
A priority queue for getting the minimum element in log N time.

- `#size`
- `#push(e)` to insert any object to the priority queue.
- `#top` to get the top element, this will not pop the element.
- `#pop` to pop and return the top element.

### Example
Priority queue for getting the largest numbers.

```ruby
q = PriorityQueue.new
(0...100).each{ q << -rand(0xff) }
while i = q.pop; p -i; end # print in decreasing order
```

## Segment Tree
[Segment tree](https://en.wikipedia.org/wiki/Segment_tree) for updating and range query in log time complexity.

- `#initialize(size, init_value = 0, &merge = nil)` to initialize a segment tree, `merge` is defaulted to sum function. `merge` is called when merging two children nodes to their parent node.
- `#update(index, value)` to update a value in `index`.
- `#query(range)` to query a result (range is in `Range` class).

### Example
A minimal segment tree. (If the element could be array, use
`{|i, j| (i <=> j) < 1 ? i : j` instead.)

```ruby
st = SegmentTree.new(a.size, Float::INFINITY){|i, j| i < j ? i : j}
(0...100).each{|i| st.update(i, rand(0xff)) }
st.query(42..74)
```

## Sorted Hash
A red-black tree for key-sorted key-value pairs. Methods below are similar to `Hash`.

- `#initialize(default = nil, &default_proc = nil)`
- `#empty?`
- `#length`, `#size`
- `#[](key)`
- `#[]=(key, value)`
- `#delete(key)`
- `#key?(key)`
- `#keys`, `#values`
- `#to_a`, `#to_h`, `#to_s`
- `#each(&block)`
- `#invert`
- `#first`, `#shift`

## Z Algorithm
Z algorithm calculates Z array for a string `str`, which `z[i]` stores the length of the longest common prefix of `str` and `str[i..]`. See [geeksforgeeks](https://www.geeksforgeeks.org/z-algorithm-linear-time-pattern-searching-algorithm/) and [codeforces](https://codeforces.com/blog/entry/3107) for more explanation.

Notice the `z[0]` is meaningless by its nature and set to be `0`.

- `get_z_array(str)`
