require "spec_helper"

module BinarySearchTree
  # TRAVERSAL TESTS
  # this tree is structured like:
  #
  # │       ┌── 8
  # │   ┌── 7
  # │   │   └── 6
  # └── 5
  #     │   ┌── 4
  #     └── 3
  #         └── 2
  #             └── 1
  RSpec.describe Traversal do
    subject(:traversal) { described_class.new(node, &block) }

    let(:block) { nil }
    let(:node) do
      root = Node.new(5)
      root.left_child = Node.new(3)
      root.left_child.left_child = Node.new(2)
      root.left_child.left_child.left_child = Node.new(1)
      root.left_child.right_child = Node.new(4)

      root.right_child = Node.new(7)
      root.right_child.left_child = Node.new(6)
      root.right_child.right_child = Node.new(8)

      root
    end

    describe "#level_order" do
      context "without any arugments" do
        it "returns an array of the values in level order" do
          level_order_elements = [5, 3, 7, 2, 4, 6, 8, 1]

          expect(traversal.level_order).to eq level_order_elements
        end
      end

      context "when given a block" do
        let(:block) { :abs2 }

        it "returns an array with each value having run through the block in level order" do
          expected_values = [25, 9, 49, 4, 16, 36, 64, 1]
          expect(traversal.level_order).to eq expected_values
        end
      end
    end

    describe "#inorder" do
      context "without any block" do
        it "returns an array of the values sorted order" do
          sorted_elements = [1, 2, 3, 4, 5, 6, 7, 8]

          expect(traversal.inorder).to eq sorted_elements
        end
      end

      context "with a block" do
        let(:block) { :succ }

        it "returns an array with each value having run through the block in sorted order" do
          expected_values = [2, 3, 4, 5, 6, 7, 8, 9]
          expect(traversal.inorder).to eq expected_values
        end
      end
    end

    describe "#preorder" do
      context "without any block" do
        it "returns an array of the values listed out in pre-order" do
          preorder_elements = [5, 3, 2, 1, 4, 7, 6, 8]
          expect(traversal.preorder).to eq preorder_elements
        end
      end

      context "with a block" do
        let(:block) { :pred }

        it "returns an array with each value having run through the block in preorder" do
          expected_values = [4, 2, 1, 0, 3, 6, 5, 7]
          expect(traversal.preorder).to eq expected_values
        end
      end
    end

    describe "#postorder" do
      context "without any block" do
        it "returns an array with the values listed in post-order" do
          postorder_elements = [1, 2, 4, 3, 6, 8, 7, 5]
          expect(traversal.postorder).to eq postorder_elements
        end
      end

      context "with a block" do
        let(:block) { :to_f }

        it "returns an array with the values listed in postorder" do
          expected_values = [1.0, 2.0, 4.0, 3.0, 6.0, 8.0, 7.0, 5.0]
          expect(traversal.postorder).to eq expected_values
        end
      end
    end
  end
end
