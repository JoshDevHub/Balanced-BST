require "spec_helper"

require_relative "../../lib/binary_search_tree"

module BinarySearchTree
  RSpec.describe Tree do
    describe "::build" do
      it "returns a new tree with the given elements" do
        array = [5, -1, 3, 20, 4]
        tree = described_class.build(array)

        expect(tree.inorder).to eq array.sort
      end
    end

    describe "#insert" do
      subject(:tree) { described_class.build([1, 2, 3, 10]) }

      context "when the given value is not in the tree" do
        it "adds a new node to the tree with the given value and preservers binary search property" do
          tree.insert(4)
          expect(tree.inorder).to eq [1, 2, 3, 4, 10]
        end
      end

      context "when the given value is already in the tree" do
        it "does nothing" do
          tree.insert(3)
          expect(tree.inorder).to eq [1, 2, 3, 10]
        end
      end
    end

    describe "#delete" do
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
      #
      # This gives me an opportunity to test different `#delete` scenarios
      subject(:tree) { described_class.build([1, 2, 3, 4, 5, 6, 7, 8]) }

      context "when the target node is a leaf" do
        it "removes the node from the tree" do
          expect { tree.delete(1) }.to change(tree, :inorder)
            .from([1, 2, 3, 4, 5, 6, 7, 8])
            .to([2, 3, 4, 5, 6, 7, 8])
        end
      end

      context "when the target node has one child" do
        it "removes the node from the tree" do
          expect { tree.delete(2) }.to change(tree, :inorder)
            .from([1, 2, 3, 4, 5, 6, 7, 8])
            .to([1, 3, 4, 5, 6, 7, 8])
        end
      end

      context "when the target node has two children" do
        it "removes the node from the tree" do
          expect { tree.delete(3) }.to change(tree, :inorder)
            .from([1, 2, 3, 4, 5, 6, 7, 8])
            .to([1, 2, 4, 5, 6, 7, 8])
        end
      end

      context "when the target node is the root" do
        it "removes the node from the tree" do
          expect { tree.delete(5) }.to change(tree, :inorder)
            .from([1, 2, 3, 4, 5, 6, 7, 8])
            .to([1, 2, 3, 4, 6, 7, 8])
        end
      end

      context "when the target node is not in the tree" do
        it "does not affect the structure" do
          expect { tree.delete(100) }.not_to change(tree, :inorder)
        end
      end
    end

    describe "#include?" do
      subject(:tree) { described_class.build([1, 2, 3]) }

      it "returns false when the structure does not contain the item" do
        expect(tree.include?(5)).to be false
      end

      it "returns true when the structure includes the item in the right subtree" do
        expect(tree.include?(3)).to be true
      end

      it "returns true when the structure includes the item in the left subtree" do
        expect(tree.include?(1)).to be true
      end
    end

    describe "#level_order" do
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
      # level order traversal should proceed through each layer of children
      subject(:tree) { described_class.build([1, 2, 3, 4, 5, 6, 7, 8]) }

      context "without any arugments" do
        it "returns an array of the values in level order" do
          level_order_elements = [5, 3, 7, 2, 4, 6, 8, 1]

          expect(tree.level_order).to eq level_order_elements
        end
      end

      context "when given a block" do
        it "returns an array with each value having run through the block in level order" do
          block = ->(value) { value**2 }
          expected_values = [25, 9, 49, 4, 16, 36, 64, 1]

          expect(tree.level_order(&block)).to eq expected_values
        end
      end
    end
  end
end
