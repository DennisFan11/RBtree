class_name TreeCRUD extends RefCounted

#region Tool Zone
enum {BLACK, RED, DOUBLE_BLACK}
func _make_treeNode(val)-> TreeNode: # NOTE 建立節點
	var node = preload("res://treeNode/treeNode.tscn").instantiate()
	MainScene.add_new_node(node)
	node.val = val
	node.color = RED # 初始化為red
	return node

func _delete_treeNode(node:TreeNode): # NOTE 刪除節點
	if is_left_child(node):
		node.P.L = null
	elif is_right_child(node):
		node.P.R = null
	node.queue_free()
	#node.L = null
	#node.R = null
	#node.P = null
	#node.PP = null

func is_left_child(node:TreeNode)-> bool: # NOTE 是左節點
	if !node or !node.P: return false 
	return (node and node.P and node.P.L == node)
func is_right_child(node:TreeNode)-> bool: # NOTE 是右節點
	return (node and node.P and node.P.R == node)
func get_neighbor(node:TreeNode)->TreeNode:
	return node.R if is_left_child(node) else node.L
func get_uncle(node:TreeNode)-> TreeNode: # NOTE 取得叔叔節點
	if node.P and node.P.P:
		if is_left_child(node.P):
			return node.P.P.R
		else:
			return node.P.P.L
	return null

#endregion



#
