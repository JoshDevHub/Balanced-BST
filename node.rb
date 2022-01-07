# frozen_string_literal: true

# class for each point on a data tree
class Node
  attr_accessor :data, :left_child, :right_child

  include Comparable

  def initialize(data)
    @data = data
    @left_child = nil
    @right_child = nil
  end

  def <=>(other)
    node.data <=> other.data
  end

  def two_children?
    left_child && right_child
  end
end
