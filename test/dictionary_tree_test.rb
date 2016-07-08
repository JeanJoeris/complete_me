require "SimpleCov"
SimpleCov.start
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
    test_tree = DictionaryTree.new
    test_tree.insert("ab")

    assert_equal 2, test_tree.count_nodes
  end

  def test_count_5_nodes
    test_tree = DictionaryTree.new
    test_tree.insert("abc")
    test_tree.insert("ace")

    assert_equal 5, test_tree.count_nodes
  end

  def test_count_words
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
    skip
    dictionary = File.read("/usr/share/dict/words")[0..1999].chomp
    partial_dict_count = dictionary.split("\n").count
    test_tree = DictionaryTree.new
    test_tree.populate(dictionary)

    assert_equal partial_dict_count, test_tree.count
  end

  def test_can_add_whole_dictionary
    skip
    dictionary = File.read("/usr/share/dict/words")
    test_tree = DictionaryTree.new
    test_tree.populate(dictionary)
    assert test_tree
  end

  def test_count_whole_dictionary
    skip
    dictionary = File.read("/usr/share/dict/words")
    test_tree = DictionaryTree.new
    test_tree.populate(dictionary)

    assert_equal 235886, test_tree.count
  end

  def test_finds_nil_if_not_there
    test_tree = DictionaryTree.new
    test_tree.insert("a")

    assert_equal nil, test_tree.find("b")
  end

  def test_can_find_substring_with_one_word
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

  def test_find_words_from_substring
    words = ["pizza", "pizzaria", "pizzicato", "foobar", "cello"]
    test_tree = DictionaryTree.new
    words.each do |word|
      test_tree.insert(word)
    end
    expected_words = words[0..2]

    assert_equal expected_words, test_tree.suggest("piz").sort
  end


  def test_find_words_from_valid_word

    words = ["pizza", "pizzaria", "pizzaafoo", "pizzicato", "foobar", "cello"]
    test_tree = DictionaryTree.new
    words.each do |word|
      test_tree.insert(word)
    end
    expected_words = words[0..2].sort

    assert_equal expected_words, test_tree.suggest("pizza")
  end

  def test_find_word_with_invalid_word

    words = ["pizza", "pizzaria", "pizzaafoo", "pizzicato", "foobar", "cello"]
    test_tree = DictionaryTree.new
    words.each do |word|
      test_tree.insert(word)
    end
    refute test_tree.find("half-life 3")
  end

  def test_access_node_selection_count_found_in_tree
    test_tree = DictionaryTree.new
    test_tree.insert("a")

    assert_equal 0, test_tree.find("a").selection_count
  end

  def test_select_word_with_1_word_dictionary
    test_tree = DictionaryTree.new
    test_tree.insert("carpet")
    n = 2
    n.times do
      test_tree.select("car", "carpet")
    end

    assert_equal n, test_tree.find("carpet").selection_count
  end

  def test_select_word_in_multi_word_dictionary
    test_tree = DictionaryTree.new
    test_tree.insert("pizza")
    test_tree.insert("pizzicato")
    test_tree.insert("pizzaria")
    test_tree.select("piz", "pizzicato")

    test_tree.select("piz", "pizzicato")
    test_tree.select("piz", "pizza")

    assert_equal 2, test_tree.find("pizzicato").selection_count
    assert_equal 1, test_tree.find("pizza").selection_count
    assert_equal 0, test_tree.find("pizzaria").selection_count

  end

  def test_get_word_node_for_one_word
    test_tree = DictionaryTree.new
    test_tree.insert("foo")

    assert_equal [test_tree.find("foo")], test_tree.get_word_nodes
  end

  def test_selecting_1_word_once_changes_suggest_order
    test_tree = DictionaryTree.new
    test_tree.insert("pizza")
    test_tree.insert("pizzicato")
    test_tree.insert("pizzaria")
    test_tree.select("piz", "pizzicato")

    assert_equal "pizzicato", test_tree.suggest("piz").first
  end

  def test_suggest_order_with_multiple_selects
    test_tree = DictionaryTree.new
    test_tree.insert("pizza")
    test_tree.insert("pizzicato")
    test_tree.insert("pizzaria")
    test_tree.select("piz", "pizzaria")
    test_tree.select("piz", "pizzaria")
    test_tree.select("piz", "pizza")

    assert_equal ["pizzaria", "pizza", "pizzicato"], test_tree.suggest("piz")
  end

  def test_diverse_word_selection_and_suggestion
    test_tree = DictionaryTree.new
    test_tree.insert("badger")
    test_tree.insert("badder")
    test_tree.insert("baddest")
    test_tree.insert("mushroom")
    test_tree.insert("mushrom") # totally a thing
    test_tree.insert("snake")
    test_tree.insert("snoopy")
    test_tree.insert("foobar")
    test_tree.insert("fox")

    4.times do
      test_tree.select("bad", "badger")
    end

    2.times do
      test_tree.select("mush", "mushroom")
    end

    1.times do
      test_tree.select("sna", "snake")
    end
    assert_equal "badger", test_tree.suggest("badg").first
    assert_equal "snake", test_tree.suggest("sna").first
  end

  def test_select_partial_dictionary
    test_tree = DictionaryTree.new
    dictionary = File.read('./test/medium.txt')
    test_tree.populate(dictionary)
    3.times do
      test_tree.select("un", "unpagan")
    end
    2.times do
      test_tree.select("un", "unactively")
    end
    1.times do
      test_tree.select("ple", "plesiosaur")
    end
    test_tree.count_nodes
    assert_equal "unpagan", test_tree.suggest("un")[0]
    assert_equal "unactively", test_tree.suggest("un")[1]
    assert_equal "plesiosaur", test_tree.suggest("ple")[0]
  end

  def test_select_entire_dictioary
    test_tree = DictionaryTree.new
    dictionary = File.read("/usr/share/dict/words")
    test_tree.populate(dictionary)
    test_tree.count_nodes
    10.times do   # cause Aardwolf
      test_tree.select("aardwolf", "aardwolf")
    end
    5.times do   # cause Aardwolf
      test_tree.select("be", "bezonian")
    end
    4.times do
      test_tree.select("be", "bee")
    end
    3.times do
      test_tree.select("cel", "cello")
    end
    assert_equal "bezonian", test_tree.suggest("be")[0]
    assert_equal "cello", test_tree.suggest("ce")[0]
    assert_equal "aardwolf", test_tree.suggest("a")[0]
  end

  def test_delete_word_decreases_word_count

    test_tree = DictionaryTree.new
    test_tree.insert("pizza")
    test_tree.delete("pizza")

    assert_equal 0, test_tree.count
  end

  def test_delete_decreases_node_count
    test_tree = DictionaryTree.new
    test_tree.insert("pizza")
    test_tree.insert("pizz")
    test_tree.delete("pizza")

    assert_equal 4, test_tree.count_nodes
  end

  def test_will_not_suggest_deleted_word
    test_tree = DictionaryTree.new
    test_tree.insert("pizza")
    test_tree.insert("pizz")
    test_tree.delete("pizza")
    p test_tree.find("pizza")

    assert_equal ["pizz"], test_tree.suggest("pizz")

  end

  def test_cannot_find_deleted_word

    test_tree = DictionaryTree.new
    test_tree.insert("pizza")
    test_tree.delete("pizza")

    # p test_tree.find("pizza")
    assert [], test_tree.find("pizza")
  end

  def test_delete_in_small_tree
    test_tree = DictionaryTree.new
    test_tree.insert("badger")
    test_tree.insert("badder")
    test_tree.insert("baddest")
    test_tree.insert("mushroom")
    test_tree.insert("mushrom")
    test_tree.insert("snake")
    test_tree.insert("snoopy")
    test_tree.insert("foobar")
    test_tree.insert("fox")

    test_tree.delete("mushroom")
    # p test_tree.find("mushroom")
    assert [], test_tree.find("mushroom")
    assert "mushrom", test_tree.find("mushrom")
  end

  def test_can_find_node_one_above_deleted_word
    skip
    test_tree = DictionaryTree.new
    test_tree.insert("pizza")
    test_tree.insert("pizz")
    test_tree.delete("pizza")

    assert_equal "pizz", test_tree.find("pizz").substring
  end

  def test_deletion_with_full_tree
    skip
    expected_words = ["pizzle", "pizzicato", "pizzeria", "pize"]
    test_tree = DictionaryTree.new
    dictionary = File.read("/usr/share/dict/words")
    test_tree.populate(dictionary)
    test_tree.delete("pizza")
    puts "looking for pizza!"
    # if test_tree.find("pizza") != []
    #   puts test_tree.find("pizza").inspect
    # end
    assert [], test_tree.find("pizza")
    assert expected_words, test_tree.suggest("piz")
  end

end
