require "minitest"
require "minitest/autorun"
require "./lib/linked_list"
require "pry"

class LinkedListTest < Minitest::Test
    def test_write_next_node
      test_node = Node.new("placeholder data")
      test_node_2 = Node.new("this is the 2nd node's data")
      test_node.link = test_node_2
      # second_node = test_node.get_next_node

      expected_next_node_data = "this is the 2nd node's data"

      assert_equal Node, test_node.link.class
      assert_equal expected_next_node_data, test_node.link.data
    end

    def test_can_have_third_node
      test_node = Node.new("First node! ")
      test_node_2 = Node.new("Second node! ")
      test_node_3 = Node.new("Third node! ")
      test_node.link = test_node_2
      test_node_2.link = test_node_3

      expected_first_node_data = "First node! "
      expected_second_node_data = "Second node! "
      expected_third_node_data = "Third node! "

      assert_equal expected_first_node_data, test_node.data
      assert_equal expected_second_node_data, test_node.link.data
      assert_equal expected_third_node_data, test_node.link.link.data

    end

    def test_it_pushes
      # list = LinkedList.new("Notorious RBG")
      # node_2_data = "internet access is a civil/human right"
      # list.push(node_2_data)
      #
      # assert_equal node_2_data, list.head.link.data

      linked_list = LinkedList.new("Mace Windu isn't dead!")
      linked_list.push("Don't listen to George")
      first_expected_data = "Mace Windu isn't dead!"
      second_expected_data = "Don't listen to George"

      assert_equal linked_list.head.data, first_expected_data
      assert_equal linked_list.head.link.data,  second_expected_data
    end

end
