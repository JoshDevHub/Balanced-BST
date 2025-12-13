# frozen_string_literal: true

module BinarySearchTree
  class Tree
    class << self
      def build(array)
        sorted_uniq_array = array.uniq.sort
        root = recursively_build_root(sorted_uniq_array)

        new(root)
      end

      def recursively_build_root(array)
        return if array.empty?

        mid_idx = array.length / 2
        root = Node.new(array[mid_idx])
        root.left_child = recursively_build_root(array[...mid_idx])
        root.right_child = recursively_build_root(array[(mid_idx + 1)..])

        root
      end
    end

    def initialize(root = nil)
      @root = root
    end

    def pretty_print(node = @root, prefix = '', is_left: true)
      return if node.nil?

      pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false)
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
      pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}")
    end

    def insert(value, curr_node = @root)
      return Node.new(value) if curr_node.nil?

      return curr_node if curr_node.data == value

      recursively_set(method: :insert, value:, node: curr_node)
    end

    def delete(value, curr_node = @root)
      return curr_node unless curr_node
      return recursively_set(method: :delete, value:, node: curr_node) if curr_node.data != value
      return curr_node.left_child || curr_node.right_child unless curr_node.two_children?

      inorder_succ = curr_node.succ
      curr_node.data = inorder_succ.data
      curr_node.right_child = delete(inorder_succ.data, curr_node.right_child)
      curr_node
    end

    def include?(value) = !find_node(value, @root).nil?

    def level_order(&) = Traversal.new(@root, &).level_order

    def inorder(&) = Traversal.new(@root, &).inorder

    def preorder(&) = Traversal.new(@root, &).preorder

    def postorder(&) = Traversal.new(@root, &).postorder

    def height(value)
      target = find_node(value)
      return if target.nil?

      calculate_height(target)
    end

    def depth(value)
      distance = 0
      find_node(value) { distance += 1 } || return

      distance
    end

    def balanced?
      calculate_height(@root) { |left, right| return false if (left - right).abs > 1 }
      true
    end

    def rebalance
      return if balanced?

      @root = self.class.recursively_build_root(inorder)
    end

    private

    def recursively_set(method:, value:, node:)
      if node.data > value
        node.left_child = public_send(method, value, node.left_child)
      else
        node.right_child = public_send(method, value, node.right_child)
      end

      node
    end

    def find_node(value, node = @root, &)
      return if node.nil?

      return node if value == node.data

      yield if block_given?
      if value > node.data
        find_node(value, node.right_child, &)
      else
        find_node(value, node.left_child, &)
      end
    end

    def calculate_height(node, &)
      return -1 if node.nil?

      left_height = calculate_height(node.left_child, &)
      right_height = calculate_height(node.right_child, &)
      yield(left_height, right_height) if block_given?

      [left_height, right_height].max + 1
    end
  end
end
