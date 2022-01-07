# frozen_string_literal: true

require_relative 'node'
require 'pry-byebug'

# class that holds logic for creating balanced binary search trees
class Tree
  attr_accessor :root

  def initialize(data)
    @root = build_tree(data)
  end

  def build_tree(array, start_index = nil, end_index = nil)
    # binding.pry
    if start_index.nil? && end_index.nil?
      array = array.sort.uniq
      start_index = 0
      end_index = array.length - 1
    end
    return nil if start_index > end_index

    mid_index = (start_index + end_index) / 2
    root_node = Node.new(array[mid_index])
    root_node.left_child = build_tree(array, start_index, (mid_index - 1))
    root_node.right_child = build_tree(array, (mid_index + 1), end_index)
    root_node
  end
end

# small test cases
test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
small_test = [1, 2, 3, 4]
my_tree = Tree.new(test_array)
p my_tree.root
