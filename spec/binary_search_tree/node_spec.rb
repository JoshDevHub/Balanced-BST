require "spec_helper"

require_relative "../../lib/binary_search_tree"

module BinarySearchTree
  RSpec.describe Node do
    describe "leaf?" do
      subject(:node) { described_class.new(10) }

      it "is true when left and right children are absent" do
        expect(node.leaf?).to be true
      end

      it "is false when a left child is present" do
        node.left_child = described_class.new(30)
        expect(node.leaf?).to be false
      end

      it "is false when a right child is present" do
        node.right_child = described_class.new(40)
        expect(node.leaf?).to be false
      end
    end

    describe "two_children?" do
      subject(:node) { described_class.new(10) }

      it "is false with no children" do
        expect(node.two_children?).to be false
      end

      it "is false with one child" do
        node.right_child = described_class.new(5)
        expect(node.two_children?).to be false
      end

      it "is true with two children" do
        node.left_child = described_class.new(5)
        node.right_child = described_class.new(10)

        expect(node.two_children?).to be true
      end
    end
  end
end
