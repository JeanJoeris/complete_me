require "minitest"
require "minitest/autorun"
require "./lib/arbitrary_node"
require "pry"

class ArbitraryNodeTest < Minitest::Test

  def test_holds_data
    expected_value = "Indiana Jones"
    test_node = ArbitraryNode.new(expected_value)

    assert_equal expected_value, test_node.data
  end

  def test_starts_with_empty_array_of_children
    expected_value = []
    test_node = ArbitraryNode.new("foo")

    assert_equal expected_value, test_node.children
  end

  def test_can_read_and_write_to_children
    first_test_data = "Hello World"
    second_test_data = "Goonight wWrld"
    test_node = ArbitraryNode.new("root node")
    test_node.children.push(first_test_data)
    test_node.children.push(second_test_data)

    assert_equal first_test_data, test_node.children.first
    assert_equal second_test_data, test_node.children[1]
  end

  def test_add_child_node
    first_test_data = "I like big butts"
    second_test_data = "and I cannot lie."
    test_node = ArbitraryNode.new("root container")
    test_node.add_child_node(first_test_data)
    test_node.add_child_node(second_test_data)

    assert_equal first_test_data, test_node.children.first.data
    assert_equal second_test_data, test_node.children[1].data
  end

end
