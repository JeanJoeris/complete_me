require '/Users/jean/turing/1module/project/complete_me/lib/dictionary_node'
require 'pry'
require '/Users/jean/turing/1module/project/complete_me/lib/address_parser'
require '/Users/jean/turing/1module/project/complete_me/lib/dictionary_tree'
class CompleteMe < DictionaryTree

  def suggest(substring)
    substring_node = find(substring)
    word_nodes_found = get_word_nodes(substring_node)
    if find(substring).is_word
      word_nodes_found.push(find(substring))
    end
    sort_by_selection_count(word_nodes_found)
  end

  def sort_by_selection_count(word_nodes)
    word_nodes.sort_by!{ |node| node.selection_count }
    words = word_nodes.map { |node| node.substring  }
    words.reverse
  end

  def select(substring, word)
    substring_node = find(word)
    substring_node.selected
  end

  def get_substrings(word)
    word_substrings = [""] # feels unruby way to do this
    word.chars.each do |letter|
      word_substrings << word_substrings.last + letter
    end
    word_substrings.shift # removes ""
    word_substrings.pop
    word_substrings.reverse # for pizza => [pizz, piz, pi, p]
  end

  def prune_tree(word_substrings)
    word_substrings.each do |substring|

      substring_node = find(substring)
      empty_child = substring_node.children.find do |child|
        child.children == []
      end
      substring_node.children -= [empty_child]
      break if substring_node.is_word

    end
  end

  def delete(word)
    @count -= 1 if find(word)
    word_substrings = get_substrings(word)
    find(word).is_word = false
    prune_tree(word_substrings)
  end
end
