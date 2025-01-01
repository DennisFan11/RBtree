## 紅黑樹刪除操作的實現
## 包含節點刪除和平衡維護的所有邏輯
class_name TreeRemove extends TreeCRUD

## 保存對當前樹根節點的引用
static var _root:TreeNode

## 刪除操作的入口函數
## 給定樹的根節點和要刪除的值，返回新的根節點
## @param root: 樹的根節點
## @param remove_val: 要刪除的值
## @return: 刪除操作後的新根節點
func remove(root:TreeNode, remove_val:float) -> TreeNode:
	_root = root
	return _remove_BST(root, remove_val)

## 在二叉搜索樹中執行刪除操作
## 這是第一階段，只考慮二叉搜索樹的性質，不考慮顏色
## @param node: 當前處理的節點
## @param val: 要刪除的值
## @return: 刪除後的子樹根節點
func _remove_BST(node:TreeNode, val:float) -> TreeNode:
	if node == null:
		return null
	
	# 找到要刪除的節點
	if val == node.val:
		# 調用 check 函數處理實際的刪除操作
		var replacement = check(node)
		if replacement:
			replacement.P = node.P
		return replacement
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

## 檢查並處理節點刪除的具體情況
## @param node: 要刪除的節點
## @return: 替換被刪除節點的新節點
func check(node:TreeNode) -> TreeNode:
	if !node:
		return null
		
	MainScene.message("[color=yellow]Deleting node: " + str(node.val) + ", color: " + ("BLACK" if node.color == BLACK else "RED") + "[/color]")
	
	# 情況1：葉節點（沒有子節點）
	if !node.L and !node.R:
		MainScene.message("[color=cyan]Leaf node case[/color]")
		handle_delete_leaf(node)
		return null
	
	# 情況2：只有右子節點
	elif !node.L:
		var child = node.R
		if child:
			MainScene.message("[color=cyan]Single right child case. Child value: " + str(child.val) + ", color: " + ("BLACK" if child.color == BLACK else "RED") + "[/color]")
			handle_delete_with_one_child(node, child)
			return child
		return null
	
	# 情況3：只有左子節點
	elif !node.R:
		var child = node.L
		if child:
			MainScene.message("[color=cyan]Single left child case. Child value: " + str(child.val) + ", color: " + ("BLACK" if child.color == BLACK else "RED") + "[/color]")
			handle_delete_with_one_child(node, child)
			return child
		return null
	
	# 情況4：有兩個子節點
	else:
		MainScene.message("[color=cyan]Two children case[/color]")
		
		# 先嘗試找右子樹中的最小節點（後繼）
		var successor = _find_minR(node.R)
		if successor:
			MainScene.message("[color=cyan]Found successor: " + str(successor.val) + ", color: " + ("BLACK" if successor.color == BLACK else "RED") + "[/color]")
			# 用後繼節點的值替換當前節點的值
			node.val = successor.val
			# 遞歸刪除後繼節點
			var new_right = _remove_BST(node.R, successor.val)
			node.R = new_right
			if new_right:
				new_right.P = node
		# 如果沒有找到後繼，嘗試找左子樹中的最大節點（前驅）tt
		else:
			var predecessor = _find_maxL(node.L)
			if predecessor:
				MainScene.message("[color=cyan]Found predecessor: " + str(predecessor.val) + ", color: " + ("BLACK" if predecessor.color == BLACK else "RED") + "[/color]")
				# 用前驅節點的值替換當前節點的值
				node.val = predecessor.val
				# 遞歸刪除前驅節點
				var new_left = _remove_BST(node.L, predecessor.val)
				node.L = new_left
				if new_left:
					new_left.P = node
			else:
				MainScene.message("[color=red]Error: Neither successor nor predecessor found[/color]")
		
		return node

## 處理刪除只有一個子節點的情況
## @param node: 要刪除的節點
## @param child: 要替換上去的子節點
func handle_delete_with_one_child(node:TreeNode, child:TreeNode):
	if !node or !child:
		return
		
	var node_color = node.color
	var parent = node.P
	var is_left = is_left_child(node)
	var child_is_left = (node.L == child)
	
	MainScene.message("[color=yellow]handle_delete_with_one_child - Node: " + str(node.val) + 
		", color: " + ("BLACK" if node_color == BLACK else "RED") + 
		", Child: " + str(child.val) + 
		" (" + ("LEFT" if child_is_left else "RIGHT") + ")" +
		", color: " + ("BLACK" if child.color == BLACK else "RED") + "[/color]")
	
	# 第1步：更新節點關係
	node.P = null
	
	# 第2步：更新父子關係
	if parent:
		if is_left:
			parent.L = child
		else:
			parent.R = child
			
		# 確保父節點的連接線狀態正確
		if parent.L:
			parent.L.P = parent
		if parent.R:
			parent.R.P = parent
	else:
		_root = child
	
	child.P = parent
	
	# 第3步：處理節點顏色
	if node_color == BLACK:
		if child.color == RED:
			# 如果刪除的是黑節點，子節點是紅節點，直接將子節點變黑
			MainScene.message("[color=green]BLACK node replaced by RED child, changing child to BLACK[/color]")
			child.color = BLACK
		else:
			# 如果刪除的是黑節點，子節點也是黑節點，需要修復 double black
			MainScene.message("[color=red]Both node and child are BLACK, fixing double black[/color]")
			fix_double_black_iterative(child)
	else:
		# 如果刪除的是紅節點，子節點必須變為黑色以維持性質
		if child.color == RED:
			MainScene.message("[color=green]RED node replaced by RED child, changing child to BLACK[/color]")
			child.color = BLACK
	
	_delete_treeNode(node)
	
	# 最後確保根節點是黑色
	if _root:
		_root.color = BLACK

## 處理刪除葉節點的情況
## @param node: 要刪除的葉節點
func handle_delete_leaf(node:TreeNode):
	if !node:
		return
		
	var parent = node.P
	var is_left = is_left_child(node)
	
	MainScene.message("[color=yellow]handle_delete_leaf - Node: " + str(node.val) + ", color: " + ("BLACK" if node.color == BLACK else "RED") + "[/color]")
	
	if parent:
		# 處理兄弟節點的顏色
		var sibling = get_sibling(node)
		if sibling:
			if parent.color == RED:
				MainScene.message("[color=green]Parent is RED, setting sibling to BLACK[/color]")
				sibling.color = BLACK
			else:
				MainScene.message("[color=green]Parent is BLACK, setting sibling to RED[/color]")
				sibling.color = RED
		
		# 從父節點中移除當前節點
		node.P = null
		if is_left:
			parent.L = null
		else:
			parent.R = null
			
		# 更新父節點的連接狀態
		if parent.L:
			parent.L.P = parent
		if parent.R:
			parent.R.P = parent
	else:
		_root = null
		
	# 如果是紅色葉節點，直接刪除
	if node.color == RED:
		_delete_treeNode(node)
	else:
		# 如果是黑色葉節點，需要處理 double black 問題
		MainScene.message("[color=red]BLACK leaf node, fixing double black[/color]")
		fix_double_black_iterative(node)
		_delete_treeNode(node)

## 修復 double black 問題的迭代實現
## double black 是在刪除黑色節點時可能出現的情況
## @param node: 當前的 double black 節點
func fix_double_black_iterative(node:TreeNode):
	if !node:
		return
		
	var current = node
	
	# 如果當前節點是紅色，直接變黑就可以了
	if current.color == RED:
		current.color = BLACK
		return
	
	# 當節點不是根節點時，需要繼續處理
	while current != null and current != _root:
		var parent = current.P
		if !parent:
			break
			
		var sibling = get_sibling(current)
		if !sibling:
			current = parent
			continue
			
		# 獲取兄弟節點子節點的顏色，如果子節點不存在則視為黑色
		var sibling_left_color = BLACK if !sibling.L else sibling.L.color
		var sibling_right_color = BLACK if !sibling.R else sibling.R.color
		
		# Case 1: 兄弟節點是紅色
		if sibling.color == RED:
			MainScene.message("[color=yellow]Case 1: Red sibling[/color]")
			sibling.color = BLACK
			parent.color = RED
			if is_left_child(current):
				rotL(parent)
			else:
				rotR(parent)
			sibling = get_sibling(current)
			if !sibling:
				break
		
		# Case 2: 兄弟節點是黑色，且兩個子節點都是黑色
		if sibling_left_color == BLACK and sibling_right_color == BLACK:
			MainScene.message("[color=yellow]Case 2: Black sibling with black children[/color]")
			sibling.color = RED
			
			if parent.color == RED:
				parent.color = BLACK
				break
			current = parent
			continue
		
		# Case 3: 兄弟節點是黑色，至少有一個紅色子節點
		if is_left_child(current):
			if sibling.R and sibling.R.color == RED:
				# Case 3a: 兄弟的右子是紅色（左邊情況）
				MainScene.message("[color=yellow]Case 3a: Black sibling with red right child (left case)[/color]")
				sibling.color = parent.color
				parent.color = BLACK
				sibling.R.color = BLACK
				rotL(parent)
				break
			elif sibling.L and sibling.L.color == RED:
				# Case 3b: 兄弟的左子是紅色（左邊情況）
				MainScene.message("[color=yellow]Case 3b: Black sibling with red left child (left case)[/color]")
				sibling.L.color = parent.color
				sibling.color = RED
				rotR(sibling)
			else:
				MainScene.message("[color=red]Unexpected case in left child handling[/color]")
		else:
			if sibling.L and sibling.L.color == RED:
				# Case 3c: 兄弟的左子是紅色（右邊情況）
				MainScene.message("[color=yellow]Case 3c: Black sibling with red left child (right case)[/color]")
				sibling.color = parent.color
				parent.color = BLACK
				sibling.L.color = BLACK
				rotR(parent)
				break
			elif sibling.R and sibling.R.color == RED:
				# Case 3d: 兄弟的右子是紅色（右邊情況）
				MainScene.message("[color=yellow]Case 3d: Black sibling with red right child (right case)[/color]")
				sibling.R.color = parent.color
				sibling.color = RED
				rotL(sibling)
			else:
				MainScene.message("[color=red]Unexpected case in right child handling[/color]")
	
	# 確保最終狀態正確
	if current:
		current.color = BLACK
	if _root:
		_root.color = BLACK

## 獲取節點的兄弟節點
## @param node: 當前節點
## @return: 兄弟節點，如果不存在則返回 null
func get_sibling(node:TreeNode) -> TreeNode:
	if !node or !node.P:
		return null
	if is_left_child(node):
		return node.P.R
	return node.P.L

## 在右子樹中找最小值節點（後繼）
## @param node: 子樹的根節點
## @return: 最小值節點
func _find_minR(node:TreeNode) -> TreeNode:
	if !node:
		return null
	var current = node
	while current.L != null:
		current = current.L
	return current

## 在左子樹中找最大值節點（前驅）
## @param node: 子樹的根節點
## @return: 最大值節點
func _find_maxL(node:TreeNode) -> TreeNode:
	if !node:
		return null
	var current = node
	while current.R != null:
		current = current.R
	return current

## 計算右子樹的層數
## @param node: 子樹的根節點
## @return: 層數
func laynR(node:TreeNode) -> int:
	var Rn:int = -1
	if node == null:
		return 0
	var current = node
	while current.L != null:
		Rn += 1
		current = current.L
	if current.R:
		return Rn + 1
	return Rn

## 計算左子樹的層數
## @param node: 子樹的根節點
## @return: 層數
func laynL(node:TreeNode) -> int:
	var Ln:int = -1
	if node == null:
		return 0
	var current = node
	while current.R != null:
		Ln += 1
		current = current.R
	if current.L:
		return Ln + 1
	return Ln

## 執行左旋操作
## @param P: 要旋轉的節點
func rotL(P:TreeNode):
	if !P or !P.R:  # 安全檢查
		MainScene.message("[color=red]Invalid rotation: Missing required nodes for left rotation[/color]")
		return
		
	MainScene.message("[color=yellow]L rotate ![/color]")
	var gp:TreeNode = P.P  # 祖父節點
	var fa:TreeNode = P    # 父節點
	var y:TreeNode = P.R   # 右子節點
		
	# 更新節點關係
	fa.R = y.L
	if y.L:
		y.L.P = fa
	
	y.L = fa
	fa.P = y
	y.P = gp

	# 更新祖父節點的引用
	if gp:
		if gp.L == fa:
			gp.L = y
		else:
			gp.R = y
	
	# 如果旋轉的是根節點，更新根節點引用
	if _root == fa:
		_root = y

## 執行右旋操作
## @param P: 要旋轉的節點
func rotR(P:TreeNode):
	if !P or !P.L:  # 安全檢查
		MainScene.message("[color=red]Invalid rotation: Missing required nodes for right rotation[/color]")
		return
		
	MainScene.message("[color=yellow]R rotate ![/color]")
	var gp:TreeNode = P.P  # 祖父節點
	var fa:TreeNode = P    # 父節點
	var y:TreeNode = P.L   # 左子節點
		
	# 更新節點關係
	fa.L = y.R
	if y.R:
		y.R.P = fa
	
	y.R = fa
	fa.P = y
	y.P = gp

	# 更新祖父節點的引用
	if gp:
		if gp.L == fa:
			gp.L = y
		else:
			gp.R = y
	
	# 如果旋轉的是根節點，更新根節點引用
	if _root == fa:
		_root = y
