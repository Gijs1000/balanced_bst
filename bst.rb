require 'pry'

class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
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

  def insert(int, current_node = @root, inserted = false)
    int_node = Node.new(int)
    until current_node.nil? # keep going until we have reached the end of a branch
      return if duplicate_value?(int, current_node) # doesn't allow to add a value that is already in the tree
      return int < current_node.data ? go_left(current_node, int_node) : go_right(current_node, int_node)
    end
    current_node = int_node
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
end

    # start at root
    # if int is bigger, goes right
    # if smaller goes left
    # repeat unless
    #   int is smaller than root but bigger than left
    #   int is bigger than root but smaller than right
    # if that happens, int is inserted and the rest of tree becomes children
    # if left/right = nil, int becomes node instead of nil

tree = Tree.new
p arr = [2,3,4,5,7,8,19, 12, 12]
tree.build_tree(arr)
tree.pretty_print
tree.insert(6)
tree.insert(11)
tree.pretty_print




