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

    if value > current_node.value
      current_node.right = Node.new(value)
    else
      current_node.left = Node.new(value)
    end
  end

  def delete(value)
    current_node = @root
    loop do
        next_node = (value > current_node.value) ? current_node.right : current_node.left
        return if next_node.nil?
        break if next_node.value == value
        current_node = next_node
    end
    
    current_node.(true) ? right : left
  end

  def to_s
    puts @root.value
    puts "#{@root.left.value} - #{@root.right.value}"
    puts "#{@root.left.right.value} - #{@root.right.left.value} - #{@root.right.right.value}"
  end

  private

  def prepare_array(user_array)
    user_array.uniq.sort
  end
end

test = Tree.new([1, 2, 3, 4, 5, 6])
test.insert(0)

