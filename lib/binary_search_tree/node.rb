# frozen_string_literal: true

module BinarySearchTree
  class Node
    attr_accessor :data, :left_child, :right_child

    def initialize(data)
      @data = data
      @left_child = nil
      @right_child = nil
    end

    def succ
      curr = @right_child
      curr = curr.left_child while curr&.left_child
      curr
    end

    def leaf?
      left_child.nil? && right_child.nil?
    end

    def two_children?
      !!left_child && !!right_child
    end
  end
end
