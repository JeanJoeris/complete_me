require './lib/dictionary_node'
require 'pry'

class DictionaryTree

  attr_accessor :root
  attr_reader :count



  def initialize(data = "")
    @root = DictionaryNode.new(data)
    @count = 0
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

  def get_word_nodes(node = @root, container = [])
    #if container.count >100
  #    binding.pry
#    end
    node.children.map do |child_node|
      # container.push(node.substring) if node.is_word # feels inelegant, but handles case of search substring == word
      container.push(child_node) if child_node.is_word
      get_words(child_node, container)
    end

    container
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

  def recursive_find(node = @root, queried_string)
    node.children.each do |child_node|

      if child_node.substring == queried_string
        return @result_node = child_node
      end
      unless @result_node == queried_string
        recursive_find(child_node, queried_string)
      end

    end
  end

  def find(queried_string)
    recursive_find(queried_string)
    @result_node
  end

  def suggest(substring)
    substring_node = find(substring)
    words_found = get_words(substring_node)
    if find(substring).is_word
      words_found.push(substring)
    end
    words_found.sort
  end

  def select(substring, word)
    substring_node = find(word)
    substring_node.selected
  end

end
