class_name TreeInsert extends TreeCRUD




#region insert gen by o1
#static var _root: TreeNode
#
#func _insert(root: TreeNode, insert_val: float) -> TreeNode:
	#if root == null:
		#_root = _make_treeNode(insert_val)
		#_root.color = BLACK  # 新的根節點必須是黑色
		#return _root
	#
	## 呼叫二元搜尋樹插入邏輯
	#_insert_BST(root, insert_val)
	#
	## 保證最後的根節點是黑色（可能在最後修正）
	#if _root != null:
		#_root.color = BLACK
	#return _root
#
#func _insert_BST(node: TreeNode, val: float) -> TreeNode:
	#if node == null:
		#var new_node = _make_treeNode(val)
		#if _root == null:
			#_root = new_node
		#return new_node
#
	#if val < node.val:
		#if node.L == null:
			#node.L = _make_treeNode(val)
			#node.L.P = node
			#_fix_insert(node.L)
		#else:
			#_insert_BST(node.L, val)
	#else:
		#if node.R == null:
			#node.R = _make_treeNode(val)
			#node.R.P = node
			#_fix_insert(node.R)
		#else:
			#_insert_BST(node.R, val)
	#return node
#
#func _fix_insert(node: TreeNode):
	## 若插入的節點成為根節點，設為黑色
	#if node == _root:
		#node.color = BLACK
		#return
	#
	## 如果父節點為紅色，需要進行調整
	#if node and node.P and node.P.color == RED:
		#var uncle = get_neighbor(node.P)
		#
		## Case 1: 父節點與叔叔節點皆為紅色 => 變色並向上遞迴
		#if node.P.P and uncle and uncle.color == RED:
			#node.P.color = BLACK
			#uncle.color = BLACK
			#node.P.P.color = RED
			#_fix_insert(node.P.P)
		## Case 2: 父節點為紅色，叔叔節點不存在或為黑色 => 透過旋轉修正
		#elif node.P.P:
			#node.P.P.color = RED
			#if node.P.P.L:
				#node.P.P.L.color = BLACK
			#if node.P.P.R:
				#node.P.P.R.color = BLACK
			#check_state(node)
#
#func check_state(node: TreeNode):
	## 必須確保 node, node.P, node.P.P 存在，否則無法判斷旋轉
	#if node == null or node.P == null or node.P.P == null:
		#return
#
	## LL：node 是左節點且其父節點也是左節點
	#if is_left_child(node) and is_left_child(node.P):
		#MainScene.message("[color=yellow]LL ![/color]")
		#LL(node.P.P, node.P, node.P.R)
		#return
#
	## LR：node 是右節點且其父節點是左節點
	#if is_right_child(node) and is_left_child(node.P):
		#MainScene.message("[color=yellow]LR ![/color]")
		#LR(node, node.P, node.P.P)
		#return
#
	## RL：node 是左節點且其父節點是右節點（尚未完整實作）
	#if is_left_child(node) and is_right_child(node.P):
		#MainScene.message("[color=yellow]RL ![/color]")
		## TODO: 實作 RL 旋轉
		#return
#
	## RR：node 是右節點且其父節點是右節點（尚未完整實作）
	#if is_right_child(node) and is_right_child(node.P):
		#MainScene.message("[color=yellow]RR ![/color]")
		## TODO: 實作 RR 旋轉
		#return
#
#func LL(grandfather: TreeNode, father: TreeNode, other: TreeNode):
	## 典型的 LL 對應 Right Rotation
	#if grandfather == _root:
		#_root = father
	#else:
		#if is_left_child(grandfather):
			#grandfather.P.L = father
		#else:
			#grandfather.P.R = father
	#father.P = grandfather.P
#
	#grandfather.L = other
	#if other:
		#other.P = grandfather
#
	#father.R = grandfather
	#grandfather.P = father
#
	## 重新調整顏色 (示例：把新父節點設為黑色，原祖父節點設為紅色)
	#father.color = BLACK
	#grandfather.color = RED
#
#func LR(node: TreeNode, father: TreeNode, grandfather: TreeNode):
	## 先對 father 做一次左旋
	#father.R = node.L
	#if node.L != null:
		#node.L.P = father
	#node.L = father
	#father.P = node
#
	## 再對 grandfather 做一次右旋
	#grandfather.L = node.R
	#if node.R != null:
		#node.R.P = grandfather
	#node.R = grandfather
	#
	## 最後連接 node 與曾祖父
	#node.P = grandfather.P
	#if grandfather.P == null:
		#_root = node
	#else:
		#if is_left_child(grandfather):
			#grandfather.P.L = node
		#else:
			#grandfather.P.R = node
#
	#grandfather.P = node
#
	## 顏色調整：將 node 設為黑色，其他設為紅色（依需求可再調整）
	#node.color = BLACK
	#father.color = RED
	#grandfather.color = RED

#endregion

#region insert
## interface NOTE 函數簽名不允許更動
func insert(root:TreeNode, insert_val:float) -> TreeNode:
	if root == null:
		return _make_treeNode(insert_val)
	
	# 插入後的平衡與顏色調整
	_root = root
	var new_node = _insert_BST(root, insert_val)
	#_root.color = BLACK # 保證根節點為黑色
	return _root

static var _root:TreeNode
func _insert_BST(node:TreeNode, val:float) -> TreeNode:
	if node == null:
		return _make_treeNode(val)
	
	if val < node.val:
		if node.L == null:
			node.L = _make_treeNode(val)
			node.L.P = node
			_fix_insert(node.L)
		else:
			_insert_BST(node.L, val)
	else:
		if node.R == null:
			node.R = _make_treeNode(val)
			node.R.P = node
			_fix_insert(node.R)
		else:
			_insert_BST(node.R, val)
	return node

func _fix_insert(node:TreeNode): # 調整顏色,旋轉 
	if node == _root: node.color = BLACK
	if node and node.P and node.P.color == RED: # NOTE case 1 & case 2 
		if node.P.P and get_neighbor(node.P) and get_neighbor(node.P).color == RED:
			node.P.color = BLACK
			get_neighbor(node.P).color = BLACK
			node.P.P.color = RED
			_fix_insert(node.P.P)
		elif node.P.P: # NOTE case 2 變色
			node.P.P.color = RED
			if node.P.P.L:
				node.P.P.L.color = BLACK
			if node.P.P.R:
				node.P.P.R.color = BLACK
			check_state(node.P.P)
	# NOTE 插入結束



func check_state(node:TreeNode): # NOTE case 4 旋轉前判斷型態
	if !(node.P and node.P.P):
		return
	## LL case 3
	if is_left_child(node) and is_left_child(node.P): # NOTE 是左節點 & 父節點是左節點
		MainScene.message("[color=yellow]LL ![/color]")
		LL(node.P.P, node.P, node.P.R)
		return
	## LR
	if is_right_child(node) and is_left_child(node.P): # NOTE 是右節點 & 父節點是左節點
		MainScene.message("[color=yellow]LR ![/color]")
		#LR(node, node.P, node.P.P) TODO
		return
	## RL
	if is_left_child(node) and is_right_child(node.P): # NOTE 是左節點 & 父節點是右節點
		MainScene.message("[color=yellow]RL ![/color]")
		return
	## RR
	if is_right_child(node) and is_right_child(node.P): # NOTE 是右節點 & 父節點是右節點
		MainScene.message("[color=yellow]RR ![/color]")
		return

func LL(grandfather:TreeNode, father: TreeNode, other: TreeNode):
	if grandfather == _root:  # 重置根節點
		_root = father
	else:
		if is_left_child(grandfather):
			grandfather.P.L = father
		else:
			grandfather.P.R = father
	grandfather.P = father
	if other:
		other.P = grandfather
	grandfather.L = other
	father.R = grandfather
	father.P = null
	father.L.color = RED
	father.R.color = RED

func LR(node:TreeNode, father:TreeNode, grandfather:TreeNode): # BUG
	node.P = null
	grandfather.P = node
	if grandfather == _root:  # 重置根節點
		_root = node
	else:
		if is_left_child(grandfather):
			grandfather.P.L = node
		else:
			grandfather.P.R = node
	father.R = node.L
	grandfather.L = node.R
	if node.L:
		node.L.P = father.R
	if node.R:
		node.R.P = grandfather.L
	
	_root.L = father
	father.P = _root
	_root.R = grandfather
	grandfather.P = _root

#endregion
