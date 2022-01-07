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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  def insert(value, curr_node = root)
    return Node.new(value) if curr_node.nil?

    return curr_node if curr_node.data == value

    if curr_node.data < value
      curr_node.right_child = insert(value, curr_node.right_child)
    else
      curr_node.left_child = insert(value, curr_node.left_child)
    end
    curr_node
  end

  def min_value_node(node)
    current = node
    current = current.left_child until current.left_child.nil?
    current
  end

  # TODO: needs more testing
  def delete(value, curr_node = root)
    return curr_node if curr_node.nil?

    if value < curr_node.data
      curr_node.left_child = delete(value, curr_node.left_child)
    elsif value > curr_node.data
      curr_node.right_child = delete(value, curr_node.right_child)
    else
      if curr_node.left_child.nil?
        temp = curr_node.right_child
        curr_node = nil
        temp
      elsif curr_node.right_child.nil?
        temp = curr_node.left_child
        curr_node = nil
        temp
      else
        temp = min_value_node(curr_node.right_child)
        curr_node.data = temp.data
        curr_node.right_child = temp.right_child
      end
    end
    curr_node
  end
end

# small test cases
test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
small_test = [1, 2, 3, 4]
my_tree = Tree.new(test_array)
my_tree.insert(24)
my_tree.delete(4)
p my_tree.root

my_tree.pretty_print
