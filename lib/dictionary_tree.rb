require '/Users/jean/turing/1module/project/complete_me/lib/dictionary_node'
require 'pry'

class DictionaryTree

  attr_accessor :root
  attr_reader :count



  def initialize(data = "")
    @root = DictionaryNode.new(data)
    @count = 0
    @node_count = 0
    @result_node = nil # feels unruby to do this, but it adds a class wide variable
  end

  def insert(word)
    @count += 1
    current_node = @root
    word.chars.each do |character|

      unless current_node.find(character)
        current_node.add(character)
      end
      if current_node.find(character) != nil
        current_node = current_node.find(character)
      end
      if current_node.substring == word
        current_node.is_word = true
      end

    end
  end

  def populate(words_joined)
    words = words_joined.split("\n")
    words.each do |word|
      insert(word)
    end
  end

  def get_words(node = @root)
    word_nodes = get_word_nodes(node)
    word_nodes.map { |node| node.substring }
  end

  def get_word_nodes(node = @root, container = [])
    node.children.map do |child_node|
      container.push(child_node) if child_node.is_word
      get_word_nodes(child_node, container)
    end
    container
  end

  def recursive_find(node = @root, recursive_depth = 0, queried_string)
    node.children.each do |child_node|
      break if @result_node
      if child_node.substring == queried_string
        @result_node = child_node
      end
      # binding.pry
      if child_node.substring == queried_string[0..recursive_depth]
        recursive_depth += 1
        recursive_find(child_node, recursive_depth, queried_string)
      end

    end
  end

  def find(queried_string)
    @result_node = nil
    recursive_find(queried_string)
    @result_node
  end

  def sort_by_selection_count(word_nodes)
    word_nodes.sort_by!{ |node| node.selection_count }
    words = word_nodes.map { |node| node.substring  }
    words.reverse
  end

  def suggest(substring)
    substring_node = find(substring)
    word_nodes_found = get_word_nodes(substring_node)
    if find(substring).is_word
      word_nodes_found.push(find(substring))
    end
    sort_by_selection_count(word_nodes_found)
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
    word_substrings.pop   # removes the word
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
    # binding.pry
    find(word).is_word = false
    prune_tree(word_substrings)
  end

  # kept around for testing traversal and pruning.
  # counting method used in count is more performant,
  # but that could be right while the tree is not
  def count_nodes(node = @root)
    node.children.map do |child_node|
      @node_count +=1
      # binding.pry if child_node.is_word
      count_nodes(child_node)
    end
    @node_count
  end

end
