class_name TreeRemove extends TreeCRUD

## 保存對當前樹根節點的引用
static var _root:TreeNode

## 刪除指定值的節點
func remove(val) -> TreeNode:
	if !_root:
		return null
	
	MainScene.message("[color=yellow]開始刪除節點 " + str(val) + "[/color]")
	
	# 第一步：執行標準的BST刪除
	var result = _remove_BST(_root, val)
	
	# 確保根節點是黑色
	if _root:
		_root.color = BLACK
	
	return _root

## 在二叉搜索樹中執行刪除操作
func _remove_BST(node:TreeNode, val:float) -> TreeNode:
	if !node:
		return null
	
	# 找到要刪除的節點
	if val == node.val:
		# 如果是葉子節點或只有一個子節點
		if !node.L or !node.R:
			return _handle_simple_delete(node)
		
		# 如果有兩個子節點，找到中序後繼節點
		var successor = _find_min(node.R)
		node.val = successor.val
		node.R = _remove_BST(node.R, successor.val)
		if node.R:
			node.R.P = node
		
	# 在左子樹中搜索
	elif val < node.val:
		if node.L:
			var new_left = _remove_BST(node.L, val)
			node.L = new_left
			if new_left:
				new_left.P = node
	
	# 在右子樹中搜索
	else:
		if node.R:
			var new_right = _remove_BST(node.R, val)
			node.R = new_right
			if new_right:
				new_right.P = node
	
	return node

## 處理簡單的刪除情況（節點是葉子或只有一個子節點）
func _handle_simple_delete(node:TreeNode) -> TreeNode:
	var child = node.L if node.L else node.R
	var is_black_node = (node.color == BLACK)
	
	# 如果是紅色節點，直接刪除
	if node.color == RED:
		_delete_treeNode(node)
		return child
	
	# 如果是黑色節點且有一個紅色子節點
	if child and child.color == RED:
		child.color = BLACK
		_delete_treeNode(node)
		return child
	
	# 如果是黑色節點且沒有子節點或子節點是黑色
	# 這種情況會產生雙黑色問題
	_fix_double_black(node)
	
	if is_left_child(node):
		node.P.L = null
	elif is_right_child(node):
		node.P.R = null
	else:
		_root = null
	
	_delete_treeNode(node)
	return null

## 修復雙黑色問題
func _fix_double_black(node:TreeNode):
	if node == _root:
		return
	
	var sibling = get_sibling(node)
	var parent = node.P
	
	if !sibling:
		# 如果沒有兄弟節點，雙黑色問題上移到父節點
		_fix_double_black(parent)
	else:
		if sibling.color == RED:
			# Case 3: 兄弟節點是紅色
			_handle_red_sibling(node, sibling)
			sibling = get_sibling(node)  # 重新獲取新的兄弟節點
		
		# 檢查兄弟節點的子節點
		var has_red_child = (sibling.L and sibling.L.color == RED) or \
							(sibling.R and sibling.R.color == RED)
		
		if has_red_child:
			# Case 1: 兄弟是黑色且至少有一個紅色子節點
			_handle_black_sibling_with_red_child(node, sibling)
		else:
			# Case 2: 兄弟是黑色且所有子節點都是黑色
			sibling.color = RED
			if parent.color == BLACK:
				_fix_double_black(parent)
			else:
				parent.color = BLACK

## 處理紅色兄弟節點的情況
func _handle_red_sibling(node:TreeNode, sibling:TreeNode):
	sibling.color = BLACK
	node.P.color = RED
	
	if is_left_child(node):
		_rotate_left(node.P)
	else:
		_rotate_right(node.P)

## 處理黑色兄弟節點且有紅色子節點的情況
func _handle_black_sibling_with_red_child(node:TreeNode, sibling:TreeNode):
	var is_left = is_left_child(node)
	var far_child = sibling.R if is_left else sibling.L
	var near_child = sibling.L if is_left else sibling.R
	
	if far_child and far_child.color == RED:
		# 遠側有紅色子節點
		far_child.color = sibling.color
		sibling.color = node.P.color
		node.P.color = BLACK
		
		if is_left:
			_rotate_left(node.P)
		else:
			_rotate_right(node.P)
	elif near_child and near_child.color == RED:
		# 近側有紅色子節點
		near_child.color = node.P.color
		node.P.color = BLACK
		
		if is_left:
			_rotate_right(sibling)
			_rotate_left(node.P)
		else:
			_rotate_left(sibling)
			_rotate_right(node.P)

## 獲取兄弟節點
func get_sibling(node:TreeNode) -> TreeNode:
	if !node or !node.P:
		return null
	if is_left_child(node):
		return node.P.R
	return node.P.L

## 找到以node為根的子樹中的最小值節點
func _find_min(node:TreeNode) -> TreeNode:
	var current = node
	while current and current.L:
		current = current.L
	return current

## 左旋操作
func _rotate_left(node:TreeNode):
	var right_child = node.R
	node.R = right_child.L
	
	if right_child.L:
		right_child.L.P = node
	
	right_child.P = node.P
	
	if !node.P:
		_root = right_child
	elif node == node.P.L:
		node.P.L = right_child
	else:
		node.P.R = right_child
	
	right_child.L = node
	node.P = right_child

## 右旋操作
func _rotate_right(node:TreeNode):
	var left_child = node.L
	node.L = left_child.R
	
	if left_child.R:
		left_child.R.P = node
	
	left_child.P = node.P
	
	if !node.P:
		_root = left_child
	elif node == node.P.R:
		node.P.R = left_child
	else:
		node.P.L = left_child
	
	left_child.R = node
	node.P = left_child
