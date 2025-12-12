module BinarySearchTree
  class Traversal
    def initialize(node, &block)
      @node = node

      @collection = []
      block ||= ->(value) { value }
      @collection_wrapper = ->(value) { @collection << block.call(value) }
    end

    def level_order
      queue = [@node]

      until queue.empty?
        curr = queue.shift
        @collection_wrapper.call(curr.data)

        queue += [curr.left_child, curr.right_child].compact
      end

      @collection
    end

    def inorder(node = @node)
      return @collection if node.nil?

      inorder(node.left_child)
      @collection_wrapper.call(node.data)
      inorder(node.right_child)
    end

    def preorder(node = @node)
      return @collection if node.nil?

      @collection_wrapper.call(node.data)
      preorder(node.left_child)
      preorder(node.right_child)
    end

    def postorder(node = @node)
      return @collection if node.nil?

      postorder(node.left_child)
      postorder(node.right_child)
      @collection_wrapper.call(node.data)
    end
  end
end
