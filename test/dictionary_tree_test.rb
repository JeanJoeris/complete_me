require "SimpleCov"
SimpleCov.start
require "minitest"
require "minitest/autorun"
require "minitest/pride"
require "./lib/dictionary_tree"
require "pry"

class DictionaryTreeTest < Minitest::Test

  def test_is_dictionary_tree
    # skip
    test_tree = DictionaryTree.new("foo")
    assert test_tree
  end

  def test_has_root
    # skip
    test_tree = DictionaryTree.new("root")
    assert_equal "root", test_tree.root.substring
  end

  def test_root_has_no_children
    # skip
    test_tree = DictionaryTree.new("root")
    assert_equal [] , test_tree.root.children
  end

  def test_add_word
    # skip
    test_tree = DictionaryTree.new
    test_tree.insert("piz")
    second_node = test_tree.root.children.first
    third_node = second_node.children.first
    assert_equal "piz", third_node.children.first.substring
  end

  def test_add_more_than_one_word
    # skip
    test_tree = DictionaryTree.new
    test_tree.insert("piz")
    test_tree.insert("foo")
    node_1a = test_tree.root.children.first
    node_1b = test_tree.root.children.last
    node_2a = node_1a.children.first
    node_2b = node_1b.children.first
    node_3a = node_2a.children.first
    node_3b = node_2b.children.first

    assert_equal "piz", node_3a.substring
    assert_equal "foo", node_3b.substring
  end


  def test_add_two_words_starting_with_same_letters
    # skip
    word_1 = "fo"
    word_2 = "foo"
    test_tree = DictionaryTree.new
    test_tree.insert(word_1)
    test_tree.insert(word_2)
    node_1 = test_tree.root.find("f")
    node_2 = node_1.children.first
    node_3 = node_2.children.first

    assert_equal word_1, node_2.substring
    assert_equal word_2, node_3.substring
  end

  def test_get_words
    # skip
    word_1 = "pizza"
    word_2 = "pizzaria"
    word_3 = "pizzicato"
    word_4 = "pizzaaa"
    words = [word_1, word_4, word_2, word_3]
    test_tree = DictionaryTree.new
    test_tree.insert(word_1)
    test_tree.insert(word_2)
    test_tree.insert(word_3)
    test_tree.insert(word_4)


    assert_equal words, test_tree.get_words.sort
  end

  def test_populate_tree_with_small_array
    # skip
    word_1 = "pizza"
    word_2 = "pizzaria"
    word_3 = "pizzicato"
    word_4 = "pizzaaa"
    words = [word_1, word_4, word_2, word_3].sort
    words_joined = words.join("\n")
    test_tree = DictionaryTree.new
    test_tree.populate(words_joined)

    assert_equal words, test_tree.get_words
  end

  def test_count_2_nodes
    # skip
    test_tree = DictionaryTree.new
    test_tree.insert("ab")

    assert_equal 2, test_tree.count_nodes
  end

  def test_count_5_nodes
    # skip
    test_tree = DictionaryTree.new
    test_tree.insert("abc")
    test_tree.insert("ace")

    assert_equal 5, test_tree.count_nodes
  end

  def test_count_words
    # skip
    word_1 = "pizza"
    word_2 = "pizzaria"
    word_3 = "pizzicato"
    word_4 = "foobar"
    words = [word_1, word_2, word_3, word_4]
    test_tree = DictionaryTree.new
    test_tree.insert(word_1)
    test_tree.insert(word_2)
    test_tree.insert(word_3)
    test_tree.insert(word_4)

    assert_equal 4, test_tree.count
  end

  def test_count_part_of_dictionary
    # skip
    dictionary = File.read("/usr/share/dict/words")[0..1999].chomp
    partial_dict_count = dictionary.split("\n").count
    test_tree = DictionaryTree.new
    test_tree.populate(dictionary)

    assert_equal partial_dict_count, test_tree.count
  end

  def test_can_add_whole_dictionary
    # skip
    dictionary = File.read("/usr/share/dict/words")
    test_tree = DictionaryTree.new
    test_tree.populate(dictionary)
    assert test_tree
  end

  def test_count_whole_dictionary
    # skip
    dictionary = File.read("/usr/share/dict/words")
    test_tree = DictionaryTree.new
    test_tree.populate(dictionary)

    assert_equal 235886, test_tree.count
  end

  def test_finds_nil_if_not_there
    # skip
    test_tree = DictionaryTree.new
    test_tree.insert("a")

    assert_equal nil, test_tree.find("b")
  end

  def test_can_find_substring_with_one_word
    # skip
    test_tree = DictionaryTree.new
    test_tree.insert("carpet")

    assert_equal "car", test_tree.find("car").substring
  end

  def test_find_word_node
    word_1 = "Thrall"
    word_2 = "Janna"
    word_3 = "Gromm"
    words = [word_1, word_2, word_3]
    nodes = words.map do |word|
      DictionaryNode.new(word)
    end
    war_tree = DictionaryTree.new
    words.each do |word|
      war_tree.insert(word)
    end
    assert_equal nodes[2].substring, war_tree.find(word_3).substring
  end

  def test_can_find_substring_with_three_words

    test_tree = DictionaryTree.new
    test_tree.insert("pizza")
    test_tree.insert("pizzaria")
    test_tree.insert("pizzicato")

    assert_equal "pizzi", test_tree.find("pizzi").substring
  end

  def test_find_word_with_invalid_word
    words = ["pizza", "pizzaria", "pizzaafoo", "pizzicato", "foobar", "cello"]
    test_tree = DictionaryTree.new
    words.each do |word|
      test_tree.insert(word)
    end
    assert_equal nil, test_tree.find("half-life 3")
  end

  def test_get_word_node_for_one_word
    # skip
    test_tree = DictionaryTree.new
    test_tree.insert("foo")

    assert_equal [test_tree.find("foo")], test_tree.get_word_nodes
  end

end
