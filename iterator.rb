module CSC254Enumerable
  def collect
    new_array = Array.new
    self.each do |e|
      new_array << yield(e)
    end
    return new_array
  end

  def inject(init)
	memo = init.nil? ? nil:init
	self.each { |x| memo = memo.nil? ? x : yield(memo,x) }
	memo
  end

end

class List
  include CSC254Enumerable
  class Node
    attr_accessor :val, :back
    def initialize(val, back)
      @val = val
      @back = back
    end
  end

  def initialize
    @head = nil
  end

  def add(x)
    @head = Node.new(x, @head)
    self
  end

  def each
      current_node = @head
     	while current_node != nil
          	yield current_node.val
          	current_node = current_node.back
      	end
  end

end

class Tree
  include CSC254Enumerable
  attr_accessor :val, :children
  
  def initialize(val, children = nil)
    @val = val
    @children = if children.nil? then Array.new else children end
  end

  def each
	yield self.val
	tree_array = self.children
	if(tree_array != nil)
		stop = false
		sub_tree_array = Array.new
		while stop != true
			tree_array.each do |e|
				yield e.val
				if(e.children!= nil)
					sub_tree_array << e.children
				end
			end
			puts "___________________"
			puts sub_tree_array.size
			if(sub_tree_array.size == 0)
				stop = true
			else
				tree_array = sub_tree_array
				sub_tree_array.clear
			end
		end
	end
  end

  def add(x)
    child = Tree.new(x)
    @children << child
    return child
  end
end

class DoubleList
  include CSC254Enumerable
  # This queue is implemented as a circular doubly linked list
  class Node
    attr_accessor :before, :after
    attr_reader :val
    def initialize(val, before, after)
      @val = val
      @before = before
      @after = after
    end

    def done?
      false
    end
  end

  # This is a special node indicating the head of the list
  class Head < Node
    def initialize
      @val = nil
      @before = self
      @after = self
    end
    
    def done?
      true
    end

    def enqueue(x)
      new = Node.new(x, self, self.after)
      tmp = self.after
      self.after = new
      tmp.before = new
    end

    def dequeue
      tmp = self.before
      self.before = self.before.before
      self.before.after = self
      tmp.val
    end
  end

  def initialize
    @head = Head.new
  end

  def add(x)
    @head.enqueue(x)
    self
  end

  def remove
    @head.dequeue(x)
  end

  def empty?
    @head.before = @head
  end

  def inspect
    cur = @head.after
    str << "["
    until cur.done?
      str << cur.val.to_s
      str << ", " unless cur.after.done?
      cur = cur.after
    end
  end

  def each
    tempNode = @head
    while(tempNode.after.val != nil)
	yield tempNode.val
	tempNode = tempNode.after
    end			
  end

end
