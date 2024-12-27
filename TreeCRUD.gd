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
	node.queue_free()
func is_left_child(node:TreeNode)-> bool: # NOTE 是左節點
	return (node.P and node.P.L == node)
func is_right_child(node:TreeNode)-> bool: # NOTE 是右節點
	return (node.P and node.P.R == node)
func get_neighbor(node:TreeNode)->TreeNode:
	return node.R if is_left_child(node) else node.L
#endregion

#region 

## 回傳new root
#func insert(root:TreeNode, insert_val:float)-> TreeNode:
	#return _insert.insert(root, insert_val)
#
### 回傳new root
#func remove(root:TreeNode, remove_val:float)-> TreeNode:
	#return _remove.remove(root, remove_val)
#endregion


#
