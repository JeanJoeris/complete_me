class DictionaryNode
  attr_reader :substring
  attr_accessor :children
  attr_accessor :is_word
  attr_accessor :selection_count

  def initialize(data = "")
    @substring = data
    @children = []
    @is_word = false
    @selection_count = 0
  end

  def add(data)
    @children.push(DictionaryNode.new(substring + data.to_s))
  end

  def find(data)
    @children.find {|child| child.substring == substring + data}
  end

  def selected
    @selection_count +=1
  end


end
