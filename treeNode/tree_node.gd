class_name TreeNode extends Node2D
var val1:float
var val2:float
var val3:float
var L:TreeNode
var LC:TreeNode
var RC:TreeNode
var R:TreeNode


func get_tree_nodes()-> Array[TreeNode]:
	return [L, LC, RC, R]
