require './lib/arbitrary_node'
require 'pry'

class ArbitraryTree

  attr_accessor :root

  def initialize(data)
    @root = ArbitraryNode.new(data)
  end



  # feels logically next step, but no idea how to test it
  def traverse_tree(node = @root)
    node.children.map do |child_node|

      if child_node.class == ArbitraryNode
        puts child_node.data # put here cause I can't figure out how to test it sanely
        traverse_tree(child_node) if child_node.children != []
      elsif child_node.class != ArbitraryNode
        puts child_node # put here cause I can't figure out how to test it sanely
        child_node
      end

    end
  end


  # feels like I shouldn't have to deal with shoveling
  # into answer, but perhaps recurrsion enocourages this approach?
  def find(node = @root,  node_with_data = [], queried_data)
    node.children.each do |child_node|
      # if node_with_data != []
      #   binding.pry
      # end
      node_with_data << child_node if child_node.data == queried_data
      find(child_node, node_with_data, queried_data) if child_node.children != []
    end
    node_with_data.first
  end
  #
  # I believe this isn't working cause node_with_data = nil before recursive call
  # making it == nil when the data is found and everything begins breaking
  # def find(node = @root,  node_with_data = nil, queried_data)
  #   node.children.each do |child_node|
  #     if node_with_data != nil
  #       binding.pry
  #     end
  #
  #     # return node_with_data if node_with_data != nil
  #
  #     #binding.pry
  #     find(child_node, node_with_data, queried_data) if child_node.children != []
  #     node_with_data = child_node if child_node.data == queried_data
  #   end
  #   node_with_data if node_with_data != nil
  #   # node_with_data = "nooo!" if node_with_data == nil
  # end

  def find_all(node = @root,  node_with_data = [], queried_data)
    node.children.each do |child_node|
      # if node_with_data != []
      #   binding.pry
      # end
      node_with_data << child_node if child_node.data == queried_data
      find(child_node, node_with_data, queried_data) if child_node.children != []
    end
    node_with_data
  end

  def aggregate_tree(node = @root, container)
    node.children.map do |child_node|

      container.push(child_node.data)
      aggregate_tree(child_node, container) if child_node.children != []
      container

    end
  end

end
