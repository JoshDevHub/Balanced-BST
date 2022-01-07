# frozen_string_literal: true

require_relative 'node'
require 'pry-byebug'

# class that holds logic for creating balanced binary search trees
class Tree
  attr_accessor :root

  def initialize(array)
    sort_array = array.sort.uniq
    @root = build_tree(sort_array, 0, (sort_array.length - 1))
  end

  def build_tree(array, start_index, end_index)
    return nil if start_index > end_index

    mid_index = (start_index + end_index) / 2
    root_node = Node.new(array[mid_index])
    root_node.left_child = build_tree(array, start_index, (mid_index - 1))
    root_node.right_child = build_tree(array, (mid_index + 1), end_index)
    root_node
  end

  def insert(value, curr_node = root)
    # binding.pry
    return Node.new(value) if curr_node.nil?

    return curr_node if curr_node.data == value

    if curr_node.data < value
      curr_node.right_child = insert(value, curr_node.right_child)
    else
      curr_node.left_child = insert(value, curr_node.left_child)
    end
    curr_node
  end
end

# small test cases
test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
small_test = [1, 2, 3, 4]
my_tree = Tree.new(small_test)
my_tree.insert(0)
p my_tree.root
