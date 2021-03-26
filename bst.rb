require 'pry'

class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def is_childless
    @left.nil? && @right.nil?
  end

  def has_child?
    !@left.nil? || !@right.nil?
  end
end

class Tree
  attr_accessor :root


  def initialize
    @root = nil
  end

  def build_tree(arr)
    arr = clean_array(arr)
    return if arr.empty?
    return Node.new(arr[0]) if arr.size == 1
    
    mid = arr.length / 2
    root = Node.new(arr[mid])
    root.left = build_tree(arr[...mid])
    root.right = build_tree(arr[mid + 1..])
    @root = root
  end

  def clean_array(array)
    array = array.uniq.sort
  end

  def insert(int, current_node = @root)
    int_node = Node.new(int)
    until current_node.nil? # keep going until we have reached the end of a branch
      return if duplicate_value?(int, current_node) # doesn't allow to add a value that is already in the tree
      return int < current_node.data ? go_left(current_node, int_node) : go_right(current_node, int_node)
    end
    current_node = int_node
  end



  def delete(int, current_node = @root)
    # fix edge case where there is only root and one value in one branch

    if current_node.left.data == int
      if current_node.left.is_childless
        current_node.left = nil # value to remove is leaf
      else # node has one child
        current_node.left.left.nil? ? current_node.left = current_node.left.right : current_node.left = current_node.left.left
      # TO-DO: case where node has two children. Need to find in-order successor.
      
      end

    elsif current_node.right.data == int
      if current_node.right.is_childless
        current_node.right = nil # value to remove is leaf
      else # node has one child
        current_node.right.left.nil? ? current_node.right = current_node.right.right : current_node.right = current_node.right.left
      # TO-DO: case where node has two children. Need to find in-order successor.

      end

    else
      int < current_node.data ? current_node = current_node.left : current_node = current_node.right
      delete(int, current_node)
    end
  end

  def find(int, current_node = @root)
    return current_node if current_node.data == int
    return false if current_node.is_childless
    int < current_node.data ? current_node = current_node.left : current_node = current_node.right
    find(int, current_node)
  end
    
  def go_left(current_node, int_node)
    if current_node.left.nil?
      current_node.left = int_node
    elsif int_node.data < current_node.left.data
      go_left(current_node.left, int_node)
    else
      temp_node = current_node.left
      current_node.left = int_node
      temp_node.data < current_node.left.data ? current_node.left.left = temp_node : current_node.left.right = temp_node
    end
  end

  def go_right(current_node, int_node)
    if current_node.right.nil?
      current_node.right = int_node
    elsif int_node.data > current_node.right.data
      go_right(current_node.right, int_node)
    else
      temp_node = current_node.right
      current_node.right = int_node
      temp_node.data < current_node.right.data ? current_node.right.left = temp_node : current_node.right.right = temp_node
    end
  end

  def duplicate_value?(int, node)
    if int == node.data 
      puts "\nerror, cannot insert duplicate value #{int}\n\n"
      true
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def level_order(current_node = @root, lo_array = [], queue = [])
    return lo_array if current_node.nil? # lo_array stands for level-order array
  
    lo_array << current_node.data
    queue << current_node.left unless current_node.left.nil?
    queue << current_node.right unless current_node.right.nil?
    level_order(queue.shift, lo_array, queue)
  end

  def pre_order(current_node = @root, arr = [])
    return arr if current_node.nil?

    arr << current_node.data
    pre_order(current_node.left, arr)
    pre_order(current_node.right, arr)
  end

  def pre_order_nodes(current_node = @root, arr = [])
    return arr if current_node.nil?

    arr << current_node
    pre_order_nodes(current_node.left, arr)
    pre_order_nodes(current_node.right, arr)
  end


  def in_order(current_node = @root, arr = [])
    return arr if current_node.nil?

    in_order(current_node.left, arr)
    arr << current_node.data
    in_order(current_node.right, arr)
  end

  def post_order(current_node = @root, arr = [])
    return arr if current_node.nil?

    post_order(current_node.left, arr)
    post_order(current_node.right, arr)
    arr << current_node.data
  end

  def height(current_node = @root, height = 0)
    return height - 1 if current_node.nil?
  
    height += 1
    height_left = height(current_node.left, height)
    height_right = height(current_node.right, height)
    height_left > height_right ? height = height_left : height = height_right
  end

  def depth(node)
    tree_height = height(@root)
    node_height = height(node)
    depth = tree_height - node_height
  end

  def balanced?
    pre_order_nodes.all? { |node| height(node.left) == height(node.right) }
  end

  def rebalance
    arr = in_order
    build_tree(arr)
  end
end

tree = Tree.new
p arr = Array.new(15) { rand(1..100) }
tree.build_tree(arr)
tree.pretty_print
p tree.balanced?
p tree.level_order
p tree.pre_order
p tree.in_order
p tree.post_order
tree.insert(105)
tree.insert(108)
tree.insert(106)
tree.pretty_print
p tree.balanced?
tree.rebalance
tree.pretty_print
p tree.level_order
p tree.pre_order
p tree.in_order
p tree.post_order
