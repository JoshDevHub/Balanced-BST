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
      subject(:tree) { described_class.new(root) }

      let(:root) { Node.new(10) }
      let(:traversal) { instance_double(Traversal, level_order: []) }

      before do
        allow(Traversal).to receive(:new).with(root).and_return(traversal)
      end

      it "creates a traversal and calls `#level_order` on it" do
        tree.level_order
        expect(traversal).to have_received(:level_order)
      end

      it "forwards blocks to the new traversal" do
        tree.level_order(&:succ)
        expect(Traversal).to have_received(:new).with(root, &:succ)
      end
    end

    describe "#inorder" do
      subject(:tree) { described_class.new(root) }

      let(:root) { Node.new(10) }
      let(:traversal) { instance_double(Traversal, inorder: []) }

      before do
        allow(Traversal).to receive(:new).with(root).and_return(traversal)
      end

      it "creates a traversal and calls `#inorder` on it" do
        tree.inorder
        expect(traversal).to have_received(:inorder)
      end

      it "forwards blocks to the new traversal" do
        tree.inorder(&:succ)
        expect(Traversal).to have_received(:new).with(root, &:succ)
      end
    end

    describe "#preorder" do
      subject(:tree) { described_class.new(root) }

      let(:root) { Node.new(10) }
      let(:traversal) { instance_double(Traversal, preorder: []) }

      before do
        allow(Traversal).to receive(:new).with(root).and_return(traversal)
      end

      it "creates a traversal and calls `#preorder` on it" do
        tree.preorder
        expect(traversal).to have_received(:preorder)
      end

      it "forwards blocks to the new traversal" do
        tree.preorder(&:succ)
        expect(Traversal).to have_received(:new).with(root, &:succ)
      end
    end

    describe "#postorder" do
      subject(:tree) { described_class.new(root) }

      let(:root) { Node.new(10) }
      let(:traversal) { instance_double(Traversal, postorder: []) }

      before do
        allow(Traversal).to receive(:new).with(root).and_return(traversal)
      end

      it "creates a traversal and calls `#postorder` on it" do
        tree.postorder
        expect(traversal).to have_received(:postorder)
      end

      it "forwards blocks to the new traversal" do
        tree.postorder(&:succ)
        expect(Traversal).to have_received(:new).with(root, &:succ)
      end
    end
  end
end
