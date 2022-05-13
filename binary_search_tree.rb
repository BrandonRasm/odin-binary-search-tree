# frozen_string_literal: true

# class for storing an individual node value
class Node
  include Comparable
  attr_accessor :value, :left, :right

  def <=>(other)
    @value <=> other.value
  end

  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end
end

# Pass in a array on initialization. Auto creates and balances a tree on initialize
# but removes duplicated in array D:
class Tree
  def initialize(user_array)
    tree_array = prepare_array(user_array)  
    @root = build_tree(tree_array, 0, arr.size - 1)
  end

  def build_tree(arr, first, last)
    return if first > last

    mid = (first + last) / 2
    root = Node.new(arr[mid])

    root.left = build_tree(arr, first, mid - 1)
    root.right = build_tree(arr, mid + 1, last)

    root
  end

  def prepare_array(user_array)
    user_array.uniq.sort
  end
end
