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
    @root = build_tree(tree_array, 0, tree_array.size - 1)
  end

  def build_tree(arr, first, last)
    return if first > last

    mid = (first + last) / 2
    root = Node.new(arr[mid])

    root.left = build_tree(arr, first, mid - 1)
    root.right = build_tree(arr, mid + 1, last)

    root
  end

  def insert(value)
    current_node = @root
    loop do
      return raise 'Duplicate value' if value == current_node.value

      next_node = value > current_node.value ? current_node.right : current_node.left
      break if next_node.nil?

      current_node = next_node
    end

    value > current_node.value ? current_node.right = Node.new(value) : current_node.left = Node.new(value)
  end

  def delete(value)
    current_node = @root
    loop do
      next_node = value > current_node.value ? current_node.right : current_node.left
      return if next_node.nil?
      break if next_node.value == value

      current_node = next_node
    end

    current_node.call(true) ? right : left
  end

  def to_s
    puts @root.value
    to_s_recursive(@root)
  end



  private

  def prepare_array(user_array)
    user_array.uniq.sort
  end

  def to_s_recursive(current_node)
    puts current_node.left.value unless current_node.left.nil?
    to_s_recursive(current_node.left) unless current_node.left.nil?
    puts current_node.right.value unless current_node.right.nil?
    to_s_recursive(current_node.right) unless current_node.right.nil?
  end
end

test = Tree.new([1, 2, 3, 4, 5, 6])
test.to_s
test.insert(13)
test.to_s