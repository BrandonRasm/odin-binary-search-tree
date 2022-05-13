# frozen_string_literal: true

# class for storing an individual node value
class Node
  include Comparable
  attr_accessor :value

  def <=>(other)
    @value <=> other.value
  end

  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end
end

# Pass in an array on initialization. Auto creates and balances a tree on initialize
class Tree
    def initialize(arr)
        @root = build_tree(arr,0,arr.size - 1)
    end

    def build_tree(arr,first,last)
        
    end
end
