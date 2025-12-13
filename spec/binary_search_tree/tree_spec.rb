require "spec_helper"

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

    describe "#height" do
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
      subject(:tree) { described_class.build([1, 2, 3, 4, 5, 6, 7, 8]) }

      it "returns the height of the given target node when the value is in the tree", :aggregate_failures do
        expect(tree.height(8)).to eq 0
        expect(tree.height(5)).to eq 3
        expect(tree.height(7)).to eq 1
        expect(tree.height(3)).to eq 2
      end

      it "returns `nil` when the value is not in the tree" do
        expect(tree.height(10)).to be_nil
      end
    end

    describe "#depth" do
      subject(:tree) { described_class.build([1, 2, 3, 4, 5, 6, 7, 8]) }

      it "returns the depth of the node with the given value if the value is in the tree", :aggregate_failures do
        expect(tree.depth(5)).to eq 0
        expect(tree.depth(3)).to eq 1
        expect(tree.depth(8)).to eq 2
        expect(tree.depth(1)).to eq 3
      end

      it "returns `nil` when the given value is not in the tree" do
        expect(tree.depth(10)).to be_nil
      end
    end

    describe "#balanced?" do
      subject(:tree) { described_class.build([1, 2, 3]) }

      context "when the tree is balanced" do
        it "returns true" do
          expect(tree.balanced?).to be true
        end
      end

      context "when the root is not balanced" do
        before do
          # insert a few nodes greater (or less than) all existing nodes to quickly create an imbalance
          tree.insert(100)
          tree.insert(101)
          tree.insert(102)
        end

        it "returns false" do
          expect(tree.balanced?).to be false
        end
      end

      context "when there's an 'even' imbalance" do
        # tree structured like:
        # │           ┌── 5
        # │       ┌── 4
        # │   ┌── 3
        # └── 2
        #     └── 1
        #         └── -1
        #             └── -2
        # Even though the root node's heights are even in both subtrees,
        #   this tree is unbalanced. This is because the nodes with values
        #   `3` and `1` are unbalanced, and unbalance at any node means the
        #   entire tree is unbalanced
        subject(:tree) { described_class.build([1, 2, 3]) }

        before do
          tree.insert(-1)
          tree.insert(-2)
          tree.insert(4)
          tree.insert(5)
        end

        it "returns false" do
          expect(tree.balanced?).to be false
        end
      end

      context "with an empty tree" do
        subject(:empty_tree) { described_class.new }

        it "returns true" do
          expect(empty_tree.balanced?).to be true
        end
      end

      context "with a tree containing only one node" do
        subject(:tree) { described_class.new(Node.new(1)) }

        it "returns true" do
          expect(tree.balanced?).to be true
        end
      end
    end

    describe "#rebalance" do
      subject(:tree) { described_class.build([1, 2, 3]) }

      context "when the tree is unbalanced" do
        before do
          tree.insert(100)
          tree.insert(101)
          tree.insert(102)
        end

        it "rebalances the tree" do
          expect { tree.rebalance }.to change(tree, :balanced?).from(false).to(true)
        end
      end

      context "when the tree is balanced" do
        it "does not change the balance of the tree" do
          expect { tree.rebalance }.not_to change(tree, :balanced?)
        end
      end
    end
  end
end
