# frozen_string_literal: true

# class for storing an individual node value
class Node
  include Comparable
  attr_accessor :value, :left, :right

  def <=>(other)
    return @value <=> other unless other.is_a?(Node)

    @value <=> other.value
  end

  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end

  def right?(child)
    child == @right
  end

  def child_count
    counter = 0
    counter += 1 unless @right.nil?
    counter += 1 unless @left.nil?
    counter
  end

  def only_child
    return raise 'has 2 children' if child_count == 2
    return raise 'has 0 childern' if child_count.zero?
    return @left if @right.nil?

    @right
  end
end

# Pass in a array on initialization. Auto creates and balances a tree on initialize
# but removes duplicated in array D:
class Tree
  def initialize(user_array)
    tree_array = prepare_array(user_array)
    @root = build_tree(tree_array, 0, tree_array.size - 1)
    @counter = 0
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
    pair = find_child_parent_pair(@root, value)
    delete_node = pair[0]
    parent = pair[1]
    return delete_root_node if parent.nil?

    # checks if node to be deleted has no child and dereferences and returns if so
    return if delete_childless_node(delete_node, parent)

    # bulk of work for delete function
    new_child = move_up(delete_node, parent, true)

    # checks if delete_node is already dereferenced in the tree
    return if parent.right == new_child || parent.left == new_child

    parent.right?(delete_node) ? parent.right = new_child : parent.left = new_child
  end

  def to_s
    puts @root.value
    to_s_recursive(@root)
  end

  def find(value)
    return @root if @root == value

    current_node = @root
    next_node = nil
    loop do
      next_node = current_node > value ? current_node.left : current_node.right
      return next_node if next_node == value
      break if next_node.nil?

      current_node = next_node
    end
    nil
  end

  def level_order(node = @root, queue = Queue.new, &block)
    yield node
    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?
    return if queue.empty?

    level_order(queue.pop, queue, &block)
  end

  def preorder(node = @root, arr = [], &block)
    block = proc { |current_node| arr << current_node.value } unless block_given?
    preorder(node.left, arr, &block) unless node.left.nil?
    block.call(node)
    preorder(node.right, arr, &block) unless node.right.nil?
    arr
  end

  def inorder(node = @root, arr = [], &block)
    block = proc { |current_node| arr << current_node.value } unless block_given?
    block.call(node)
    inorder(node.left, arr, &block) unless node.left.nil?
    inorder(node.right, arr, &block) unless node.right.nil?
    arr
  end

  def postorder(node = @root, arr = [], &block)
    block = proc { |current_node| arr << current_node.value } unless block_given?

    postorder(node.left, arr, &block) unless node.left.nil?
    postorder(node.right, arr, &block) unless node.right.nil?
    block.call(node)
    arr
  end

  def height(node)
    left_height = !node.left.nil? ? 1 + height(node.left) : 0
    right_height = !node.right.nil? ? 1 + height(node.right) : 0
    [left_height, right_height].max
  end

  def depth(node)
    return 0 if @root == node

    counter = 0
    current_node = @root
    loop do
      counter += 1
      next_node = node > current_node ? current_node.right : current_node.left
      return nil if next_node.nil?
      return counter if next_node == node

      current_node = next_node
    end
  end

  def balanced?(node = @root)
    return true if node.nil?
    return false unless child_height_delta(node) < 2

    balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    return if balanced?

    tree_array = prepare_array(preorder)
    @root = build_tree(tree_array, 0, tree_array.size - 1)
  end

  private

  # returns boolean weather it did anything
  def delete_childless_node(delete_node, parent)
    if delete_node.child_count.zero?
      parent.right?(delete_node) ? parent.right = nil : parent.left = nil
      return true
    end
    false
  end

  # returns arr containing found node(index 0) and its parent(index 1)
  def find_child_parent_pair(current_node, value)
    return [current_node, nil] if value == current_node.value # if deleted node is root node

    next_node = nil
    loop do
      next_node = value > current_node.value ? current_node.right : current_node.left
      return raise 'Value not found ' if next_node.nil?

      break if next_node.value == value

      current_node = next_node
    end
    [next_node, current_node]
  end

  def prepare_array(user_array)
    user_array.uniq.sort
  end

  def to_s_recursive(current_node)
    puts current_node.left.value unless current_node.left.nil?
    to_s_recursive(current_node.left) unless current_node.left.nil?
    puts '--'
    puts current_node.right.value unless current_node.right.nil?
    to_s_recursive(current_node.right) unless current_node.right.nil?
  end

  # will return the child of node after modifying pointers
  def move_up(node, parent, first)
    case node.child_count
    when 2
      child = node.left
      move_up(child, node, false)
      child.right = node.right if child == node.left
      child = node.left
    when 1
      move_up_with_1_child(node, parent, first)
      # when 0:
      # if no children child will be nil
    end
    child
  end

  def move_up_with_1_child(node, parent, first)
    child = node.right.nil? ? node.left : node.right
    return if parent.right?(node) == node.right?(child) # returns if node line is straight

    # if node line is not straight
    node.left = nil
    node.right = nil
    parent.right?(node) ? parent.right = child : parent.left = child
    unless first # checks if move_up has been called at least once
      insert_node_at(node, child) # if first==true node will be the value we are delete so we avoid inserting it
      insert_node_at(parent.right, child) # uf first==true then parent.right will never risk being unassigned so inserting is pointless
    end
  end

  def insert_node_at(node, node_location)
    current_node = node_location
    loop do
      return raise 'Duplicate value' if node.value == current_node.value # probably unnecissary

      next_node = node.value > current_node.value ? current_node.right : current_node.left
      break if next_node.nil?

      current_node = next_node
    end

    node.value > current_node.value ? current_node.right = node : current_node.left = node
  end

  # if child cound == 2 delete function will work normally
  def delete_root_node
    return @root = @root.only_child if @root.child_count == 1
    return @root = nil if @root.child_count.zero?

    @root = move_up(@root, nil, true)
  end

  def child_height_delta(node)
    left_height = !node.left.nil? ? height(node.left) : -1
    right_height = !node.left.nil? ? height(node.right) : -1
    (left_height - right_height).abs
  end
end

test = Tree.new((Array.new(15) { rand(1..100) }))
puts 'oh no' unless test.balanced?
print_nodes = proc { |node| puts node.value }

test.level_order(&print_nodes)
puts "-----"
test.preorder(&print_nodes)
puts "-----"
test.inorder(&print_nodes)
puts "-----"
test.postorder(&print_nodes)

5.times {puts ''}

test.insert(134)
test.insert(199)
test.insert(222)
test.insert(101)

puts "oh no" unless test.balanced?

test.rebalance

puts "oh no" unless test.balanced?

5.times {puts ''}

test.level_order(&print_nodes)
puts "-----"
test.preorder(&print_nodes)
puts "-----"
test.inorder(&print_nodes)
puts "-----"
test.postorder(&print_nodes)
