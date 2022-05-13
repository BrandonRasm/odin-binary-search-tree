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
