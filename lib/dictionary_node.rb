class DictionaryNode
  attr_reader :substring
  attr_accessor :children
  attr_accessor :is_word

  def initialize(data = "")
    @substring = data
    @children = []
    @is_word = false
  end

  def add(data)
    @children.push(DictionaryNode.new(substring + data.to_s))
  end

  def find(data)
    @children.find {|child| child.substring == substring + data}
  end

end
