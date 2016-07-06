require './lib/node'

class ArbitraryNode

  attr_reader :data
  attr_accessor :children

  def initialize(data)
    @data = data
    @children = []
  end

  def add_child_node(data)
    @children.push(ArbitraryNode.new(data))
  end

end
