require '/Users/jean/turing/1module/project/complete_me/lib/dictionary_node'
require 'pry'
require '/Users/jean/turing/1module/project/complete_me/lib/address_parser'
require '/Users/jean/turing/1module/project/complete_me/lib/dictionary_tree'
class CompleteMe < DictionaryTree

end

# kept around for proving traverse counting words
# does work. @count is more performant, but could be right while the tree is not
#
# def count(node = @root)
#
#   node.children.map do |child_node|
#     @word_count +=1 if child_node.is_word
#     count(child_node)
#   end
#   @word_count
# end