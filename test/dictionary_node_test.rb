require "minitest"
require "minitest/autorun"
require "minitest/pride"
require "./lib/dictionary_node"
require "pry"

class DictionaryNodeTest < Minitest::Test
  def test_is_a_node
    node = DictionaryNode.new("foo")
    assert(node)
  end

  def test_holds_substring
    node = DictionaryNode.new("foo")
    assert_equal "foo", node.substring
  end

  def test_starts_with_no_children
    node = DictionaryNode.new("foo")

    assert_equal [], node.children
  end

  def test_add_child
    node = DictionaryNode.new
    node.add("A")
    assert_equal "A", node.children.first.substring
  end

  def test_add_child_at_second_level
    node = DictionaryNode.new
    node.add("a")
    node.children.first.add("b")
    first_child = node.children.first
    assert_equal "ab", first_child.children.first.substring
  end

  def test_is_word
    node = DictionaryNode.new
    node.add("pizza")
    node.children.first.is_word = true
    refute node.is_word
    assert node.children.first.is_word
  end

  def test_find_child
    node = DictionaryNode.new
    node.add("a")
    node.add("b")
    node.add("c")
    assert_equal node.children[0], node.find("a")
    assert_equal node.children[1], node.find("b")
    assert_equal node.children[2], node.find("c")
  end

  def test_node_has_selection_count
    a_node = DictionaryNode.new("a")

    assert_equal 0, a_node.selection_count

  end

  def test_select_node_to_increment_select

    a_node = DictionaryNode.new("a")
    a_node.selected

    assert_equal 1, a_node.selection_count
  end

end
