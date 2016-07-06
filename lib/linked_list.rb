require "./lib/node"

class LinkedList
  # a linked list is a head and the ability to push
  # a node already covers having a link to the next node

  attr_reader :head

  def initialize(data)
    @head = Node.new(data)
  end

  def push(data)
    current = @head

    until current.link == nil
      current = current.link
    end

    current.link = Node.new(data)
  end
end
