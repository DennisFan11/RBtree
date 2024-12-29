class_name TreeRemove extends TreeCRUD

## interface NOTE 函數簽名不允許更動
func remove(root:TreeNode, remove_val:float) -> TreeNode:
	return _remove_BST(root, remove_val)


func _remove_BST(node:TreeNode, val:float) -> TreeNode: # TODO BST的remove只充當佔位符
	if node == null:
		return null
	if val == node.val:
		return _remove(node)  # 返回刪除後的新子樹根
	elif val < node.val:
		if node.L:
			node.L = _remove_BST(node.L, val)  # 更新左子樹
	else:
		if node.R:
			node.R = _remove_BST(node.R, val)  # 更新右子樹
	return node  # 返回當前節點


func _remove(node:TreeNode) -> TreeNode:
	if !node.L and !node.R:  # 葉節點，直接刪除
		_delete_treeNode(node)
		return null  # 該子樹變為空
	elif node.L and !node.R:  # 僅有左子節點
		node.L.P = node.P  # 更新子節點的父節點
		_delete_treeNode(node)
		return node.L  # 返回新的子樹根
	elif !node.L and node.R:  # 僅有右子節點
		node.R.P = node.P  # 更新子節點的父節點
		_delete_treeNode(node)
		return node.R  # 返回新的子樹根
	else:  # 有左右子節點
		var successor = _find_min(node.R)
		node.val = successor.val  # 替換當前節點的值
		node.R = _remove_BST(node.R, successor.val)  # 刪除繼任節點
		return node  # 返回當前節點


func _find_min(node:TreeNode) -> TreeNode:
	while node.L:
		node = node.L
	return node
