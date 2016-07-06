require "minitest"
require "minitest/autorun"
require "minitest/pride"
require "./lib/arbitrary_tree"
require "pry"

class ArbitraryTreeTest < Minitest::Test

  def test_root_is_arbitrary_node
    expected_class = ArbitraryNode
    test_root = ArbitraryTree.new("fdsafdsa")

    assert_equal expected_class, test_root.root.class
  end

  def test_can_access_data
    expected_value = "Rogue One"
    test_root = ArbitraryTree.new(expected_value)

    assert_equal expected_value, test_root.root.data
  end

  def test_can_access_lower_data
    root_data = "Level 1"
    second_data = "Level 2"
    third_data = "Level 2a"
    fourth_data = "Level 2b"

    test_tree = ArbitraryTree.new(root_data)
    test_tree.root.add_child_node(second_data)

    second_node = test_tree.root.children.first
    second_node.add_child_node(third_data)
    second_node.add_child_node(fourth_data)

    assert_equal root_data, test_tree.root.data
    assert_equal second_data, second_node.data
    assert_equal third_data, second_node.children[0].data
    assert_equal fourth_data, second_node.children[1].data

  end

  def test_aggregate_tree_with_all_nodes_of_type_node
    test_tree = ArbitraryTree.new("root")
    data_1 = "Good movies"
    data_2 = "Bad movies"
    data = [data_1, data_2]

    good_1 = "A New Hope"
    good_2 = "Empire Strikes Back"
    good_3 = "Return of the Jedi"
    good_4 = "The Force Awakens"
    good_data = [good_1, good_2, good_3, good_4]

    bad_1 = "The Phantom Menace"
    bad_2 = "The Clone Wars"
    bad_3 = "Revenge of the Sith"
    bad_data = [bad_1, bad_2, bad_3]

    expected_value = [data[0], good_1, good_2, good_3, good_4, data[1], bad_1, bad_2, bad_3]

    # expected_value = good_data.unshift(data[0])
    # expected_value.push(data[1])
    # expected_value += bad_data

    data.each{ |datum| test_tree.root.add_child_node(datum) }

    good_data.each do |movie|
      test_tree.root.children.first.add_child_node(movie)
    end

    bad_data.each do |movie|
      test_tree.root.children.last.add_child_node(movie)
    end

    # ??? as to how I actually use traverse to get things test_it_starts_with_nothing
    # but it sure does
    collected_travels = []
    test_tree.aggregate_tree(collected_travels)
    assert_equal expected_value, collected_travels

  end

  def test_search_tree
    test_tree = ArbitraryTree.new("root")
    data_1 = "Good movies"
    data_2 = "Bad movies"
    data = [data_1, data_2]

    good_1 = "A New Hope"
    good_2 = "Empire Strikes Back"
    good_3 = "Return of the Jedi"
    good_4 = "The Force Awakens"
    good_data = [good_1, good_2, good_3, good_4]

    bad_1 = "The Phantom Menace"
    bad_2 = "The Clone Wars"
    bad_3 = "Revenge of the Sith"
    bad_data = [bad_1, bad_2, bad_3]

    data.each{ |datum| test_tree.root.add_child_node(datum) }

    good_data.each do |movie|
      test_tree.root.children.first.add_child_node(movie)
    end

    bad_data.each do |movie|
      test_tree.root.children.last.add_child_node(movie)
    end


    # assert_equal data.first, test_tree.find(data.first).data
    assert_equal bad_2, test_tree.find(bad_2).data
    assert_equal good_4, test_tree.find(good_4).data



  end

  def test_find_all
    test_tree = ArbitraryTree.new("root")
    data_1 = "Good movies"
    data_2 = "Bad movies"
    data = [data_1, data_2]

    good_1 = "A New Hope"
    good_2 = "Empire Strikes Back"
    good_3 = "Return of the Jedi"
    good_4 = "The Force Awakens"
    good_data = [good_1, good_2, good_3, good_4]

    bad_1 = "The Phantom Menace"
    bad_2 = "The Clone Wars"
    bad_3 = "Revenge of the Sith"
    bad_data = [bad_1, bad_2, bad_3]

    data.each{ |datum| test_tree.root.add_child_node(datum) }

    good_data.each do |movie|
      test_tree.root.children.first.add_child_node(movie)
    end

    bad_data.each do |movie|
      test_tree.root.children.last.add_child_node(movie)
    end
    test_tree.root.children.last.add_child_node(bad_2)

    assert_equal 2, test_tree.find_all(bad_2).count
  end

end
