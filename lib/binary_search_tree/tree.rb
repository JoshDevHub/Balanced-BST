# frozen_string_literal: true

module BinarySearchTree
  class Tree
    class << self
      def build(array)
        sorted_uniq_array = array.uniq.sort
        root = recursively_build_root(sorted_uniq_array)

        new(root)
      end

      private

      def recursively_build_root(array)
        return if array.empty?

        mid_idx = array.length / 2
        root = Node.new(array[mid_idx])
        root.left_child = recursively_build_root(array[...mid_idx])
        root.right_child = recursively_build_root(array[(mid_idx + 1)..])

        root
      end
    end

    def initialize(root)
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

      if curr_node.data < value
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

    def delete(value, curr_node = @root)
      return curr_node if curr_node.nil?

      return delete_child_helper(curr_node) if curr_node.data == value

      if curr_node.data > value
        curr_node.left_child = delete(value, curr_node.left_child)
      else
        curr_node.right_child = delete(value, curr_node.right_child)
      end
      curr_node
    end

    def delete_child_helper(curr_node)
      return curr_node.right_child || curr_node.left_child unless curr_node.two_children?

      inorder_succ = min_value_node(curr_node.right_child)
      curr_node.data = inorder_succ.data
      curr_node.right_child = delete(inorder_succ.data, curr_node.right_child)
      curr_node
    end

    def include?(value, curr_node = @root)
      return false if curr_node.nil?

      return true if curr_node.data == value

      if curr_node.data > value
        include?(value, curr_node.left_child)
      else
        include?(value, curr_node.right_child)
      end
    end

    def level_order(&) = Traversal.new(@root, &).level_order

    def inorder(&) = Traversal.new(@root, &).inorder

    def preorder(&) = Traversal.new(@root, &).preorder

    def postorder(&) = Traversal.new(@root, &).postorder

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
end
