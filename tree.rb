# frozen_string_literal: true

# class that holds logic for creating balanced binary search trees
class Tree
  attr_accessor :root

  def initialize(data)
    @root = build_tree(data)
  end

  def build_tree(array)
    array.sort.uniq
  end
end

# small test cases
test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
my_tree = Tree.new(test_array)
p my_tree.root
