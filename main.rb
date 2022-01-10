# frozen_string_literal: true

require_relative 'lib/tree'

test_array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

new_tree = Tree.new(test_array)
new_tree.pretty_print
