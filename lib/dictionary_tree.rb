require './lib/dictionary_node'
require 'pry'

class DictionaryTree

  attr_accessor :root

  def initialize(data = "")
    @root = DictionaryNode.new(data)
    @word_count = 0
    @word_container = []
  end

  def insert(word)
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

  def get_words(node = @root, container = [])
    #if container.count >100
  #    binding.pry
#    end
    node.children.map do |child_node|
      # container.push(node.substring) if node.is_word # feels inelegant, but handles case of search substring == word
      container.push(child_node.substring) if child_node.is_word
      get_words(child_node, container)
    end

    container
  end

  def count
    get_words.count
  end

  # def count(node = @root)
  #
  #   node.children.map do |child_node|
  #     @word_count +=1 if child_node.is_word
  #     count(child_node)
  #   end
  #   @word_count
  # end

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
