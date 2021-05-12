class SortedHash
  # Sorted hash is implemented as a red-black tree.
  # It's not named `OrderedHash` because the name is used in Rails.

  include Enumerable

  attr_reader :size
  attr_accessor :default, :default_proc

  class NilNode
    attr_accessor :p
    def color; BLACK; end
  end

  class Node
    attr_reader :key
    attr_accessor :value, :p, :left, :right, :color
    def initialize key, value
      @key, @value = key, value
      @p, @left, @right = NIL_NODE, NIL_NODE, NIL_NODE
      @color = RED
    end
  end

  NIL_NODE = NilNode.new
  RED, BLACK = 0, 1

  def initialize default = nil, &default_proc
    @default, @default_proc = default, default_proc
    @root, @size = NIL_NODE, 0
  end

  def empty?
    @size == 0
  end

  def length
    @size
  end

  def [] key
    if n = find_node(@root, key)
      n.val
    elsif @default_proc
      @default_proc.(self, key)
    else
      @default
    end
  end

  def []= key, value
    if n = find_node(@root, key)
      n.value = value
    else
      insert(n = Node.new(key, value))
      @size += 1
    end
    value
  end

  def delete key
    if n = find_node(@root, key)
      if @size == 1
        @root = NIL_NODE
      else
        delete_node(n)
      end
      @size -= 1
      n.value
    elsif block_given?
      yield key
    end
  end

  def key? key
    !!find_node(@root, key)
  end
  alias :has_key? :key? 

  def keys
    map{|k, | k}
  end

  def key value
    find{|k, v| v == value}&.at[0]
  end

  def values
    map{|_, v| v}
  end

  def to_a
    map(&:itself)
  end

  def to_h
    h = Hash.new(*@default, &@default_proc)
    each{|k, v| h[k] = v }
    h
  end

  def to_s
    to_h.to_s
  end
  alias inspect to_s

  def each &b
    n = @root == NIL_NODE ? nil : tree_minimum(@root)
    e = Enumerator.new do |i|
      while n
        i << [n.key, n.value]
        n = successor(n)
      end
    end
    if block_given?
      e.each(&b)
      self
    else
      e
    end
  end

  def invert
    h = self.class.new(@default, &@default_proc)
    each{|k, v| h[v] = k }
    h
  end

  def shift
    if @root != NIL_NODE
      n = tree_minimum(@root)
      delete_node(n)
      [n.key, n.value]
    end
  end

  def first
    if @root != NIL_NODE
      n = tree_minimum(@root)
      [n.key, n.value]
    end
  end

  private def find_node n, key
    while n != NIL_NODE
      c = key <=> n.key
      if c == 0
        return n
      end
      n = (c == -1) ? n.left : n.right
    end
    nil
  end

  private def tree_minimum n
    while n.left != NIL_NODE
      n = n.left
    end
    n
  end

  private def successor n
    if n.right != NIL_NODE
      tree_minimum(n.right)
    else
      while n.p != NIL_NODE && n == n.p.right
        n = n.p
      end
      n.p != NIL_NODE ? n.p : nil
    end
  end

  private def left_rotate x
    y = x.right
    x.right = y.left
    if y.left != NIL_NODE
      y.left.p = x
    end
    y.p = x.p
    if x.p == NIL_NODE
      @root = y
    elsif x == x.p.left
      x.p.left = y
    else
      x.p.right = y
    end
    y.left = x
    x.p = y
  end

  private def right_rotate x
    y = x.left
    x.left = y.right
    if y.right != NIL_NODE
      y.right.p = x
    end
    y.p = x.p
    if x.p == NIL_NODE
      @root = y
    elsif x == x.p.right
      x.p.right = y
    else
      x.p.left = y
    end
    y.right = x
    x.p = y
  end

  private def insert z
    y, x = NIL_NODE, @root
    while x != NIL_NODE
      y = x
      x = ((z.key <=> x.key) == -1) ? x.left : x.right
    end
    z.p = y
    if y == NIL_NODE
      @root = z
    elsif ((z.key <=> y.key) == -1)
      y.left = z
    else
      y.right = z
    end
    z.left = z.right = NIL_NODE
    z.color = RED
    insert_fixup(z)
  end

  private def insert_fixup z
    while z.p.color == RED
      if z.p == z.p.p.left
        y = z.p.p.right
        if y.color == RED
          z.p.color = BLACK
          y.color = BLACK
          z.p.p.color = RED
          z = z.p.p
        else
          if z == z.p.right
            z = z.p
            left_rotate(z)
          end
          z.p.color = BLACK
          z.p.p.color = RED
          right_rotate(z.p.p)
        end
      else
        y = z.p.p.left
        if y.color == RED
          z.p.color = BLACK
          y.color = BLACK
          z.p.p.color = RED
          z = z.p.p
        else
          if z == z.p.left
            z = z.p
            right_rotate(z)
          end
          z.p.color = BLACK
          z.p.p.color = RED
          left_rotate(z.p.p)
        end
      end
    end
    @root.color = BLACK
  end

  private def transplant u, v
    if u.p == NIL_NODE
      @root = v
    elsif u == u.p.left
      u.p.left = v
    else
      u.p.right = v
    end
    v.p = u.p
  end

  private def delete_node z
    y = z
    y_orig_color = y.color
    if z.left == NIL_NODE
      x = z.right
      transplant(z, z.right)
    elsif z.right == NIL_NODE
      x = z.left
      transplant(z, z.left)
    else
      y = tree_minimum(z.right)
      y_orig_color = y.color
      x = y.right
      if y.p == z
        x.p = y
      else
        transplant(y, y.right)
        y.right = z.right
        y.right.p = y
      end
      transplant(z, y)
      y.left = z.left
      y.left.p = y
      y.color = z.color
    end
    if y_orig_color == BLACK
      delete_fixup(x)
    end
  end

  private def delete_fixup x
    while x != @root && x.color == BLACK
      if x == x.p.left
        w = x.p.right
        if w.color == RED
          w.color = BLACK
          x.p.color = RED
          left_rotate(x.p)
          w = x.p.right
        end
        if w.left.color == BLACK && w.right.color == BLACK
          w.color = RED
          x = x.p
        else
          if w.right.color == BLACK
            w.left.color = BLACK
            w.color = RED
            right_rotate(w)
            w = x.p.right
          end
          w.color = x.p.color
          x.p.color = BLACK
          w.right.color = BLACK
          left_rotate(x.p)
          x = @root
        end
      else
        w = x.p.left
        if w.color == RED
          w.color = BLACK
          x.p.color = RED
          right_rotate(x.p)
          w = x.p.left
        end
        if w.left.color == BLACK && w.right.color == BLACK
          w.color = RED
          x = x.p
        else
          if w.left.color == BLACK
            w.right.color = BLACK
            w.color = RED
            left_rotate(w)
            w = x.p.left
          end
          w.color = x.p.color
          x.p.color = BLACK
          w.left.color = BLACK
          right_rotate(x.p)
          x = @root
        end
      end
    end
    x.color = BLACK
  end
end
