# frozen_string_literal: true

require_relative 'node'
require 'pry-byebug'

# rubocop: disable Metrics/ClassLength
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

    return curr_node if curr_node == value

    if curr_node < value
      curr_node.right_child = insert(value, curr_node.right_child)
    else
      curr_node.left_child = insert(value, curr_node.left_child)
    end
    curr_node
  end

  def min_value_node(node)
    current = node
    current = current.left_child while current.left_child
    current
  end

  # TODO: work on length & ABC
  def delete(value, curr_node = root)
    # Base Case
    return curr_node if curr_node.nil?

    # If node has two children
    if curr_node == value && curr_node.two_children?
      inorder_succ = min_value_node(curr_node.right_child)
      curr_node.data = inorder_succ.data
      curr_node.right_child = delete(inorder_succ.data, curr_node.right_child)
    # If node has one child or no children
    elsif curr_node == value
      temp = curr_node.right_child || curr_node.left_child
      curr_node = nil
    # Continue looking for node
    else
      curr_node.left_child = delete(value, curr_node.left_child) if curr_node > value
      curr_node.right_child = delete(value, curr_node.right_child) if curr_node < value
    end
    temp || curr_node
  end

  def find(value, curr_node = root)
    return if curr_node.nil?

    return curr_node if curr_node == value

    if curr_node > value
      find(value, curr_node.left_child)
    else
      find(value, curr_node.right_child)
    end
  end

  def level_order(node = root)
    queue = [node]
    collection = []
    until queue.empty?
      curr_node = queue.shift
      queue << curr_node.left_child if curr_node.left_child
      queue << curr_node.right_child if curr_node.right_child
      yield(curr_node) if block_given?
      collection << curr_node.data
    end
    collection
  end

  def inorder(node = root, &block)
    return if node.nil?

    collection = []
    collection << inorder(node.left_child, &block) if node.left_child
    block.call(node) if block_given?
    collection << node.data
    collection << inorder(node.right_child, &block) if node.right_child
    collection.flatten
  end

  def preorder(node = root, &block)
    return if node.nil?

    collection = []
    block.call(node) if block_given?
    collection << node.data
    collection << preorder(node.left_child, &block) if node.left_child
    collection << preorder(node.right_child, &block) if node.right_child
    collection.flatten
  end

  def postorder(node = root, &block)
    return if node.nil?

    collection = []
    collection << postorder(node.left_child, &block) if node.left_child
    collection << postorder(node.right_child, &block) if node.right_child
    block.call(node) if block_given?
    collection << node.data
    collection.flatten
  end

  def height(node = root)
    return 0 if node.nil? || node.no_children?

    left_height = height(node.left_child)
    right_height = height(node.right_child)
    1 + [left_height, right_height].max
  end

  def depth(target, node = root)
    return nil if target.nil? || !find(target)

    return 0 if node == target

    edge_count = if target > node.data
                   depth(target, node.right_child)
                 else
                   depth(target, node.left_child)
                 end
    edge_count + 1
  end

  def balanced?
    subtree_diff = height(root.left_child) - height(root.right_child)
    subtree_diff.abs <= 1
  end

  def rebalance
    return if balanced?

    new_array = inorder
    self.root = build_tree(new_array, 0, (new_array.length - 1))
  end
end

# small test cases
test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
small_test = [1, 2, 3, 4, 5]
my_tree = Tree.new(test_array)
my_tree.insert(24)
my_tree.insert(50)
my_tree.insert(69)
# my_tree.insert(1000)
my_tree.rebalance
p my_tree.balanced?
p my_tree.root

my_tree.pretty_print
