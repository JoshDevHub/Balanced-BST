# frozen_string_literal: true

# class for each point on a data tree
class Node
  attr_reader :data
  attr_accessor :left_child, :right_child

  include Comparable

  def initialize(data)
    @data = data
    @left_child = nil
    @right_child = nil
  end

  def <=>(other)
    node.data <=> other.data
  end
end
