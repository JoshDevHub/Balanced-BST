# Balanced Binary Search Tree

An exercise in building a balanced BST using Ruby.

## Features

This project has a `Tree` class that can build binary search trees from an array of numbers. `Tree` also has several methods for traversing and managing the tree:

1. `#insert(value)` -- inserts a new given value into the tree.
2. `#delete(value)` -- deletes a given value from the tree.
3. `#find(value)` -- returns the node in the tree with the given value.
4. `#level_order` -- traverses the tree in breadth-first fashion
5. `#inorder` -- traverses the tree inorder
6. `#preorder` -- traverses the tree preorder
7. `#postorder` -- traverses the tree postorder
8. `#height(node)` -- returns the height of the given node (that is the number of edges in longest path from the node to a leaf node)
9. `#depth(target)` -- returns the depth of the target node (that is the number of edge in path from the node to the tree's root)
10. `#balanced?` -- returns `true` if the tree is balanced
11. `#rebalance` -- rebalances a tree if it is unbalanced

In `main.rb` there is a short script that tests most of the above methods using a random dataset.