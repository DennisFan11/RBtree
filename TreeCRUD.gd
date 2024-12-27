class_name TreeCRUD extends RefCounted

#region interface NOTE 函數簽名簿不允許更動

## 回傳new root
func insert(root:TreeNode, insert_val:float)-> TreeNode:
	if !root:
		var node = _make_treeNode()
		node.val1 = insert_val
		return node
	_insert(root, insert_val)
	return root

## 回傳new root
func remove(root:TreeNode, remove_val:float)-> TreeNode:
	return null

#endregion


func _make_treeNode()-> TreeNode:
	var node = preload("res://treeNode/treeNode.tscn").instantiate()
	MainScene.add_new_node(node)
	return node

func _delete_treeNode(node:TreeNode):
	node.queue_free()


## TODO 實作RB樹

func _insert(node:TreeNode, val):
	if node.val1 < val:
		if node.R:
			_insert(node.R, val)
		else:
			var new_node := _make_treeNode()
			new_node.val1 = val
			node.R = new_node
	else:
		if node.L:
			_insert(node.L, val)
		else:
			var new_node := _make_treeNode()
			new_node.val1 = val
			node.L = new_node
	return
















#
