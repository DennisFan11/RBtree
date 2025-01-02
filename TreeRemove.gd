class_name TreeRemove extends TreeCRUD

## 保存對當前樹根節點的引用
static var _root:TreeNode

## 格式化節點信息
func _format_node_info(node: TreeNode) -> String:
	if !node:
		return "null"
	return str(node.val)

## 打印整棵樹的狀態
func _debug_tree_state(message: String = "") -> void:
	return
	if message:
		MainScene.message("\n[color=yellow]" + message + "[/color]")
	
	if !_root:
		MainScene.message("[color=red]樹為空[/color]")
		return
		
	var current_level = []  # 當前層的節點
	var next_level = []     # 下一層的節點
	var levels = []         # 存儲所有層的節點
	var level_map = {}      # 記錄每個節點在哪一層
	
	current_level.push_back(_root)
	level_map[_root] = 0
	levels.push_back([_root])
	
	# 使用 BFS 建立層級結構
	while current_level.size() > 0:
		var node = current_level.pop_front()
		var current_level_num = level_map[node]
		
		if node.L:
			next_level.push_back(node.L)
			level_map[node.L] = current_level_num + 1
		if node.R:
			next_level.push_back(node.R)
			level_map[node.R] = current_level_num + 1
			
		if current_level.size() == 0 and next_level.size() > 0:
			levels.push_back(next_level.duplicate())
			current_level = next_level.duplicate()
			next_level.clear()
	
	# 按層級打印
	for level in range(levels.size()):
		for node in levels[level]:
			var info = "  Level " + str(level) + ": 節點值=" + str(node.val)
			info += ", 顏色=" + ("黑" if node.color == BLACK else "紅")
			info += ", 父節點=" + _format_node_info(node.P)
			info += ", 左子=" + _format_node_info(node.L)
			info += ", 右子=" + _format_node_info(node.R)
			MainScene.message(info)

## 刪除指定值的節點
func remove(val) -> TreeNode:
	if !_root:
		return null
	
	#MainScene.message("[color=yellow]開始刪除節點 " + str(val) + "[/color]")
	_debug_tree_state("刪除前的樹狀態:")
	
	# 第一步：執行標準的BST刪除
	var result = _remove_BST(_root, val)
	
	_debug_tree_state("BST刪除後的樹狀態:")
	
	# 確保根節點是黑色
	if _root:
		_root.color = BLACK
		#MainScene.message("[color=green]確保根節點為黑色[/color]")
	
	_debug_tree_state("最終的樹狀態:")
	
	return _root

## 在二叉搜索樹中執行刪除操作
func _remove_BST(node:TreeNode, val:float) -> TreeNode:
	if !node:
		#MainScene.message("[color=red]節點不存在[/color]")
		return null
	
	#MainScene.message("[color=cyan]正在搜索節點 " + str(val) + "，當前節點值=" + str(node.val) + "[/color]")
	
	# 找到要刪除的節點
	if val == node.val:
		#MainScene.message("[color=green]找到目標節點 " + str(val) + "[/color]")
		# 如果是葉子節點或只有一個子節點
		if !node.L or !node.R:
			#MainScene.message("[color=yellow]節點是葉子或只有一個子節點，進入簡單刪除處理[/color]")
			var result = _handle_simple_delete(node)
			_debug_tree_state("簡單刪除後的樹狀態:")
			return result
		
		# 如果有兩個子節點，找到中序後繼節點
		#MainScene.message("[color=yellow]節點有兩個子節點，尋找後繼節點[/color]")
		var successor = _find_min(node.R)
		#MainScene.message("[color=cyan]找到後繼節點：" + str(successor.val) + "[/color]")
		
		node.val = successor.val
		node.R = _remove_BST(node.R, successor.val)
		if node.R:
			node.R.P = node
			
		_debug_tree_state("後繼節點處理後的樹狀態:")
		
	# 在左子樹中搜索
	elif val < node.val:
		#MainScene.message("[color=cyan]目標值小於當前節點，往左子樹搜索[/color]")
		if node.L:
			var new_left = _remove_BST(node.L, val)
			node.L = new_left
			if new_left:
				new_left.P = node
	
	# 在右子樹中搜索
	else:
		#MainScene.message("[color=cyan]目標值大於當前節點，往右子樹搜索[/color]")
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
	
	MainScene.message("[color=yellow]處理簡單刪除 - 節點值=" + str(node.val) + 
		", 顏色=" + ("黑" if is_black_node else "紅") + 
		", 子節點=" + ("有" if child else "無") + "[/color]")
	
	# 如果是紅色節點，直接刪除
	if node.color == RED:
		MainScene.message("[color=green]刪除紅色節點，不需要平衡[/color]")
		if child:
			child.P = node.P
		if node == _root:
			_root = child
		elif is_left_child(node):
			node.P.L = child
		elif is_right_child(node):
			node.P.R = child
		_delete_treeNode(node)
		return child
	
	# 如果是黑色節點且有一個紅色子節點
	if child and child.color == RED:
		MainScene.message("[color=green]黑色節點有紅色子節點，子節點變黑[/color]")
		child.color = BLACK
		child.P = node.P
		if node == _root:
			_root = child
		elif is_left_child(node):
			node.P.L = child
		elif is_right_child(node):
			node.P.R = child
		_delete_treeNode(node)
		return child
	
	# 如果是黑色節點且沒有子節點或子節點是黑色
	MainScene.message("[color=red]發現雙黑色情況，需要修復[/color]")
	_fix_double_black(node)
	
	if node == _root:
		_root = null
	elif is_left_child(node):
		node.P.L = null
	else:
		node.P.R = null
	
	_delete_treeNode(node)
	return null

## 修復雙黑色問題
func _fix_double_black(node:TreeNode):
	if node == _root:
		MainScene.message("[color=green]到達根節點，修復完成[/color]")
		return
	
	var sibling = get_sibling(node)
	var parent = node.P
	
	MainScene.message("[color=yellow]修復雙黑色 - 當前節點=" + str(node.val) + 
		", 父節點=" + str(parent.val if parent else "null") + 
		", 兄弟節點=" + str(sibling.val if sibling else "null") + "[/color]")
	
	if !sibling:
		MainScene.message("[color=red]沒有兄弟節點，雙黑色上移[/color]")
		_fix_double_black(parent)
	else:
		if sibling.color == RED:
			MainScene.message("[color=cyan]Case 3: 兄弟節點是紅色[/color]")
			_handle_red_sibling(node, sibling)
			sibling = get_sibling(node)  # 重新獲取新的兄弟節點
		
		# 檢查兄弟節點的子節點
		var has_red_child = (sibling.L and sibling.L.color == RED) or \
							(sibling.R and sibling.R.color == RED)
		
		if has_red_child:
			MainScene.message("[color=cyan]Case 1: 兄弟是黑色且有紅色子節點[/color]")
			_handle_black_sibling_with_red_child(node, sibling)
		else:
			MainScene.message("[color=cyan]Case 2: 兄弟是黑色且子節點都是黑色[/color]")
			sibling.color = RED
			if parent.color == BLACK:
				MainScene.message("[color=yellow]父節點是黑色，繼續向上修復[/color]")
				_fix_double_black(parent)
			else:
				MainScene.message("[color=green]父節點是紅色，變為黑色，修復完成[/color]")
				parent.color = BLACK

## 處理紅色兄弟節點的情況
func _handle_red_sibling(node:TreeNode, sibling:TreeNode):
	MainScene.message("[color=yellow]處理紅色兄弟 - 當前節點=" + str(node.val) + 
		", 兄弟節點=" + str(sibling.val) + "[/color]")
	
	sibling.color = BLACK
	node.P.color = RED
	
	if is_left_child(node):
		MainScene.message("[color=cyan]執行左旋[/color]")
		_rotate_left(node.P)
	else:
		MainScene.message("[color=cyan]執行右旋[/color]")
		_rotate_right(node.P)

## 處理黑色兄弟節點且有紅色子節點的情況
func _handle_black_sibling_with_red_child(node:TreeNode, sibling:TreeNode):
	MainScene.message("[color=yellow]處理黑色兄弟的紅色子節點 - 當前節點=" + str(node.val) + 
		", 兄弟節點=" + str(sibling.val) + "[/color]")
	
	var is_left = is_left_child(node)
	var far_child = sibling.R if is_left else sibling.L
	var near_child = sibling.L if is_left else sibling.R
	
	if far_child and far_child.color == RED:
		MainScene.message("[color=cyan]遠側有紅色子節點[/color]")
		far_child.color = sibling.color
		sibling.color = node.P.color
		node.P.color = BLACK
		
		if is_left:
			MainScene.message("[color=cyan]執行左旋[/color]")
			_rotate_left(node.P)
		else:
			MainScene.message("[color=cyan]執行右旋[/color]")
			_rotate_right(node.P)
	elif near_child and near_child.color == RED:
		MainScene.message("[color=cyan]近側有紅色子節點[/color]")
		near_child.color = node.P.color
		node.P.color = BLACK
		
		if is_left:
			MainScene.message("[color=cyan]執行右旋後左旋[/color]")
			_rotate_right(sibling)
			_rotate_left(node.P)
		else:
			MainScene.message("[color=cyan]執行左旋後右旋[/color]")
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

## 右旋轉操作
func _rotate_right(node:TreeNode) -> void:
	_debug_tree_state("右旋轉前的樹狀態:")
	MainScene.message("[color=cyan]開始右旋轉操作 - 當前節點值=" + str(node.val) + "[/color]")
	
	if !node or !node.L:
		MainScene.message("[color=red]錯誤：無法執行右旋轉，節點或左子節點為空[/color]")
		return
		
	var left_child = node.L
	MainScene.message("步驟1: 保存左子節點 " + str(left_child.val))
	
	# 更新父節點關係
	left_child.P = node.P
	if node.P:
		if node == node.P.L:
			node.P.L = left_child
			MainScene.message("步驟2.1: 更新父節點的左子為 " + str(left_child.val))
		else:
			node.P.R = left_child
			MainScene.message("步驟2.2: 更新父節點的右子為 " + str(left_child.val))
	else:
		_root = left_child
		MainScene.message("步驟2.3: 更新根節點為 " + str(left_child.val))
	
	# 移動子樹
	node.L = left_child.R
	if left_child.R:
		left_child.R.P = node
		MainScene.message("步驟3: 移動右子樹，新父節點為 " + str(node.val))
	else:
		MainScene.message("步驟3: 右子樹為空，無需移動")
	
	# 連接節點
	left_child.R = node
	node.P = left_child
	MainScene.message("步驟4: 完成節點連接")
	
	_debug_tree_state("右旋轉後的樹狀態:")
