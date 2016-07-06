require "minitest"
require "minitest/autorun"
require "./lib/node"
require "pry"

class NodeTest < Minitest::Test

  def test_is_a_node
    empty_node = Node.new("")
    expected_class = Node

    assert_equal expected_class, empty_node.class
  end

  def test_it_starts_with_nothing
    empty_node = Node.new(nil)

    assert_equal nil, empty_node.data
  end

  def test_it_can_start_with_data
    filled_node = Node.new("Notorious RBG")
    expected_data = "Notorious RBG"

    assert_equal expected_data, filled_node.data
  end

  def test_link_starts_empty
    node = Node.new("foobar")
    expected_value = nil

    assert_equal expected_value, node.link
  end

  def test_write_data
    test_node = Node.new("MF-ing Sotomayor")
    expected_data = "MF-ing Sotomayor"

    assert_equal expected_data, test_node.data
  end

  def test_next_node_starts_empty
    test_node = Node.new("link?")
    expected_next_node = nil

    assert_equal expected_next_node, test_node.link
  end


end
