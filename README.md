# Ruby Data Structure Library
A simple library of implementations of common data structures that
are not in Ruby's built in library.

## BinaryIndexedTree

- `#add(index, value)` to add value to the `index`.
- `#sum(index)` to get the sum from index 0 to `index`.

## PriorityQueue
A priority queue for getting minimum element in logN time.

- `#size`
- `#insert(element)` to insert any object to the priority queue.
- `#top` to get the top element, this will not pop the element.
- `#pop` to pop and return the top element.

## SortedHash
A red-black tree for key-sorted key-value pair. Methods below are similar to Ruby's `Hash`.

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
