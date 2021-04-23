# Ruby Data Structure Library
A simple library of implementations of common data structures and algorithms that
are not in Ruby's built in library.

## BinaryIndexedTree (class)

- `#add(index, value)` to add value to the `index`.
- `#sum(index)` to get the sum from index 0 to `index`.

## PriorityQueue (class)
A priority queue for getting minimum element in logN time.

- `#size`
- `#insert(element)` to insert any object to the priority queue.
- `#top` to get the top element, this will not pop the element.
- `#pop` to pop and return the top element.

## SortedHash (class)
A red-black tree for key-sorted key-value pairs. Methods below are similar to Ruby's `Hash`.

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
- `#shift`

## Z Algorithm
Z algorithm calculates Z array for a string `str`, which `z[i]` stores the length of the longest common prefix of `str` and `str[i..]`. See [geeksforgeeks](https://www.geeksforgeeks.org/z-algorithm-linear-time-pattern-searching-algorithm/) and [codeforces](https://codeforces.com/blog/entry/3107) for more explanation.

Notice the `z[0]` is meaningless by its nature, in the code it's set to be 0.

- `#get_z_array(string)`
