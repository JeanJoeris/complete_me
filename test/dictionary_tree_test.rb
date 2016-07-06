require "minitest"
require "minitest/autorun"
require "minitest/pride"
require "./lib/dictionary_tree"
require "pry"

class DictionaryTreeTest < Minitest::Test

  def test_is_dictionary_tree
    test_tree = DictionaryTree.new("foo")
    assert test_tree
  end

  def test_has_root
    test_tree = DictionaryTree.new("root")
    assert_equal "root", test_tree.root.substring
  end

  def test_root_has_no_children
    test_tree = DictionaryTree.new("root")
    assert_equal [] , test_tree.root.children
  end

  def test_add_word
    test_tree = DictionaryTree.new
    test_tree.insert("piz")
    second_node = test_tree.root.children.first
    third_node = second_node.children.first
    assert_equal "piz", third_node.children.first.substring
  end

  def test_add_more_than_one_word
    test_tree = DictionaryTree.new
    test_tree.insert("piz")
    test_tree.insert("fob")
    node_1a = test_tree.root.children.first
    node_1b = test_tree.root.children.last
    node_2a = node_1a.children.first
    node_2b = node_1b.children.first
    node_3a = node_2a.children.first
    node_3b = node_2b.children.first

    assert_equal "piz", node_3a.substring
    assert_equal "fob", node_3b.substring
  end


  def test_add_two_words_starting_with_same_letters
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

  def test_aggregate_results
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


    assert_equal words, test_tree.get_words
  end

  def test_count_words
    word_1 = "pizza"
    word_2 = "pizzaria"
    word_3 = "pizzicato"
    words = [word_1, word_2, word_3]
    test_tree = DictionaryTree.new
    test_tree.insert(word_1)
    test_tree.insert(word_2)
    test_tree.insert(word_3)

    assert_equal 3, test_tree.count_words
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

  def test_can_find_substring_with_one_word
    test_tree = DictionaryTree.new
    test_tree.insert("carpet")

    assert_equal "car", test_tree.find("car").substring
  end

  def test_can_find_substring_with_three_words
    test_tree = DictionaryTree.new
    test_tree.insert("pizza")
    test_tree.insert("pizzaria")
    test_tree.insert("pizzicato")

    assert_equal "pizzi", test_tree.find("pizzi").substring
  end

  def test_find_words_from_substring
    words = ["pizza", "pizzaria", "pizzicato", "foobar", "cello"]
    test_tree = DictionaryTree.new
    words.each do |word|
      test_tree.insert(word)
    end
    expected_words = words[0..2]

    assert_equal expected_words, test_tree.search("piz")
  end


  def test_find_words_from_valid_word
    words = ["pizza", "pizzaria", "pizzaafoo", "pizzicato", "foobar", "cello"]
    test_tree = DictionaryTree.new
    words.each do |word|
      test_tree.insert(word)
    end
    expected_words = words[0..2].sort

    assert_equal expected_words, test_tree.search("pizza")
  end


end
