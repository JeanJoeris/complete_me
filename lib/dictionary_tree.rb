require './lib/dictionary_node'
require 'pry'

class DictionaryTree

  attr_accessor :root

  def initialize(data = "")
    @root = DictionaryNode.new(data)
  end

  def insert(word)
    current_node = @root
    word.chars.each do |character|

      current_node.add(character) unless current_node.find(character)
      if current_node.find(character) != nil
        current_node = current_node.find(character)
      end
      if current_node.substring == word
        current_node.is_word = true
      end

    end
  end

  def get_words(node = @root, container = [])

    node.children.map do |child_node|
      container.push(node.substring) if node.is_word # feels inelegant, but handles case of search substring == word
      container.push(child_node.substring) if child_node.is_word
      get_words(child_node, container) if child_node.children != []
    end
    container.flatten.sort.uniq
  end

  def count_words
    get_words.count
  end

  def find(node = @root, node_with_word = [], queried_string)
    node.children.each do |child_node|

      node_with_word << child_node if child_node.substring == queried_string
      find(child_node, node_with_word, queried_string) if child_node.children != []
    end
    node_with_word.first
  end

  def search(substring)
    substring_node = find(substring)
    words_found = get_words(substring_node)
  end

end
