require "SimpleCov"
SimpleCov.start
require "minitest"
require "minitest/autorun"
require "minitest/pride"
require "./lib/complete_me"
require "pry"

class CompleteMeTest < Minitest::Test
  def test_will_not_suggest_deleted_word
    # skip
    test_tree = CompleteMe.new
    test_tree.insert("pizza")
    test_tree.insert("pizz")
    test_tree.delete("pizza")

    assert_equal ["pizz"], test_tree.suggest("pizz")

  end

  def test_find_words_from_substring
    # skip
    words = ["pizza", "pizzaria", "pizzicato", "foobar", "cello"]
    test_tree = CompleteMe.new
    words.each do |word|
      test_tree.insert(word)
    end
    expected_words = words[0..2]

    assert_equal expected_words, test_tree.suggest("piz").sort
  end

  def test_find_words_from_valid_word
    # skip

    words = ["pizza", "pizzaria", "pizzaafoo", "pizzicato", "foobar", "cello"]
    test_tree = CompleteMe.new
    words.each do |word|
      test_tree.insert(word)
    end
    expected_words = words[0..2].sort

    assert_equal expected_words, test_tree.suggest("pizza")
  end

  def test_access_node_selection_count_found_in_tree
    # skip
    test_tree = CompleteMe.new
    test_tree.insert("a")

    assert_equal 0, test_tree.find("a").selection_count
  end

  def test_select_word_with_1_word_dictionary
    # skip
    test_tree = CompleteMe.new
    test_tree.insert("carpet")
    n = 2
    n.times do
      test_tree.select("car", "carpet")
    end

    assert_equal n, test_tree.find("carpet").selection_count
  end

  def test_select_word_in_multi_word_dictionary
    # skip
    test_tree = CompleteMe.new
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



  def test_selecting_1_word_once_changes_suggest_order
    # skip
    test_tree = CompleteMe.new
    test_tree.insert("pizza")
    test_tree.insert("pizzicato")
    test_tree.insert("pizzaria")
    test_tree.select("piz", "pizzicato")

    assert_equal "pizzicato", test_tree.suggest("piz").first
  end

  def test_suggest_order_with_multiple_selects
    # skip
    test_tree = CompleteMe.new
    test_tree.insert("pizza")
    test_tree.insert("pizzicato")
    test_tree.insert("pizzaria")
    test_tree.select("piz", "pizzaria")
    test_tree.select("piz", "pizzaria")
    test_tree.select("piz", "pizza")

    assert_equal ["pizzaria", "pizza", "pizzicato"], test_tree.suggest("piz")
  end

  def test_diverse_word_selection_and_suggestion
    # skip
    test_tree = CompleteMe.new
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
    # skip
    test_tree = CompleteMe.new
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
    # skip
    test_tree = CompleteMe.new
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
    # skip
    test_tree = CompleteMe.new
    test_tree.insert("pizza")
    test_tree.delete("pizza")

    assert_equal 0, test_tree.count
  end

  def test_delete_decreases_node_count
    # skip
    test_tree = CompleteMe.new
    test_tree.insert("pizza")
    test_tree.insert("pizz")
    test_tree.delete("pizza")

    assert_equal 4, test_tree.count_nodes
  end


  def test_cannot_find_deleted_word
    test_tree = CompleteMe.new
    test_tree.insert("pizza")
    test_tree.delete("pizza")

    refute test_tree.find("pizza")
    assert [], test_tree.find("pizza")
  end

  def test_delete_in_small_tree

    test_tree = CompleteMe.new
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
    assert [], test_tree.find("mushroom")
    assert "mushrom", test_tree.find("mushrom")
  end

  def test_can_find_node_one_above_deleted_word
    test_tree = CompleteMe.new
    test_tree.insert("pizza")
    test_tree.insert("pizz")
    test_tree.delete("pizza")

    assert_equal "pizz", test_tree.find("pizz").substring
  end

  def test_deletion_with_full_tree
    expected_words = ["pizzle", "pizzicato", "pizzeria", "pize"]
    test_tree = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    test_tree.populate(dictionary)
    test_tree.delete("pizza")
    # puts "looking for pizza!"
    # if test_tree.find("pizza") != []
    #   puts test_tree.find("pizza").inspect
    # end
    refute test_tree.find("pizza")
    assert [], test_tree.find("pizza")
    assert expected_words, test_tree.suggest("piz")
  end
end
