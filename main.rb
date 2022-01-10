# frozen_string_literal: true

require_relative 'lib/tree'

random_nums = (Array.new(15) { rand(1..100) })
my_tree = Tree.new(random_nums)

puts my_tree.balanced? # -> true

print_node_data = proc { |node| puts node.data }
def each_traversal(tree, &print_block)
  puts 'inorder'
  tree.inorder(&print_block)
  puts 'preorder'
  tree.preorder(&print_block)
  puts 'postorder'
  tree.postorder(&print_block)
  puts 'level order'
  tree.level_order(&print_block)
end

each_traversal(my_tree, &print_node_data)

5.times do
  my_tree.insert(rand(100..200))
end
puts my_tree.balanced? # -> false
my_tree.rebalance
puts my_tree.balanced? # -> true

my_tree.pretty_print
