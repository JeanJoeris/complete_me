class Node
# a node is data and a link

attr_accessor :link
attr_reader :data

  def initialize(data)
    @data = data
    @link = nil
  end

end
