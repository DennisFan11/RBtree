class_name TreeInsert extends TreeCRUD



#region insert
## interface NOTE 函數簽名不允許更動
func insert(root:TreeNode, insert_val:float)-> TreeNode:
	
	# 插入後的平衡與顏色調整
	_root = root
	var new_node = _insert_BST(root, insert_val)
	#_root.color = BLACK # 保證根節點為黑色
	return _root


static var _root:TreeNode

func _insert_BST(node:TreeNode, val:float) -> TreeNode:
	if node == null:
		var new_node = _make_treeNode(val)
		new_node.color = BLACK
		_root = new_node
		return
		
	if node.R and node.L:
		if node.R.color == RED and node.L.color == RED:
			node.R.color = BLACK
			node.L.color = BLACK
			if node.P:
				node.color = RED
				print(node.val)
				_case2(node)
	
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
	return

func _fix_insert(node:TreeNode)-> void: # 調整顏色,旋轉
	_case1(node)

func _case1(node:TreeNode):
	if !node.P:
		node.color = BLACK
	else:
		_case2(node)

func _case2(node:TreeNode):
	if (node.P.color == BLACK): return
	else: _case3(node)

func _case3(node:TreeNode):
	if !node or !node.P or !node.PP : return 
	var last:String = ""
	if is_right_child(node) and is_left_child(node.P):
		rotL(node)
		node = node.L
	elif is_left_child(node) and is_right_child(node.P):
		rotR(node)
		node = node.R
	node.P.color = BLACK # case 5 
	node.PP.color = RED
	print(node.val)
	if is_left_child(node) and is_left_child(node.P):
		rotR(node.P)
	else:
		rotL(node.P)
		
	



func rotL(P:TreeNode):
	MainScene.message("[color=yellow]L rotate ![/color]")
	var gp:TreeNode = P.PP
	var fa:TreeNode = P.P
	var y:TreeNode = P.L

	# 更新父節點指向
	if y:
		y.P = fa
	fa.R = y
	
	# 更新 P 和 fa 的關係
	P.L = fa
	fa.P = P

	# 更新 gp 的子節點指向
	if gp:
		if gp.L == fa:
			gp.L = P
		else:
			gp.R = P
	P.P = gp
	
	# 更新根節點
	if _root == fa:
		_root = P


func rotR(P:TreeNode):
	MainScene.message("[color=yellow]R rotate ![/color]")
	var gp:TreeNode = P.PP
	var fa:TreeNode = P.P
	var y:TreeNode = P.R

	# 更新父節點指向
	if y:
		y.P = fa
	fa.L = y
	
	# 更新 P 和 fa 的關係
	P.R = fa
	fa.P = P

	# 更新 gp 的子節點指向
	if gp:
		if gp.L == fa:
			gp.L = P
		else:
			gp.R = P
	P.P = gp
	
	# 更新根節點
	if _root == fa:
		_root = P





#
#func LL(grandfather:TreeNode, father: TreeNode, other: TreeNode):
	#MainScene.message("[color=yellow]LL ![/color]")
	#father.P = grandfather.P
	#if grandfather == _root:  # 重置根節點
		#_root = father
	#else:
		#if is_left_child(grandfather):
			#grandfather.P.L = father
		#else:
			#grandfather.P.R = father
	#grandfather.P = father
	#if other:
		#other.P = grandfather
	#grandfather.L = other
	#father.R = grandfather
	#father.P = null
	#father.color = BLACK
	#grandfather.color = RED
#
#func LR(node:TreeNode, father:TreeNode, grandfather:TreeNode): # BUG
	#MainScene.message("[color=yellow]LR ![/color]")
	#father.R = node.L
	#if node.L:
		#node.L.P = father
	#node.L = father
	#father.P = node
	#grandfather.L = node.R
	#if node.R:
		#node.R.P = grandfather
	#node.R = grandfather
	#node.P = grandfather.P
	#if grandfather.P == null:
		#_root = node
	#else:
		#if is_left_child(grandfather):
			#grandfather.P.L = node
		#else:
			#grandfather.P.R = node
	#grandfather.P = node
	#node.color = BLACK
	#father.color = RED
	#grandfather.color = RED
#
#func RL(node:TreeNode, father:TreeNode, grandfather:TreeNode): # BUG
	#MainScene.message("[color=yellow]RL ![/color]")
	#father.L = node.R
	#if node.R:
		#node.R.P = father
	#node.R = father
	#father.P = node
	#grandfather.R = node.L
	#if node.L:
		#node.L.P = grandfather
	#node.L = grandfather
	#node.P = grandfather.P
	#if grandfather.P == null:
		#_root = node
	#else:
		#if is_left_child(grandfather):
			#grandfather.P.L = node
		#else:
			#grandfather.P.R = node
	#grandfather.P = node
	#node.color = BLACK
	#father.color = RED
	#grandfather.color = RED
#
#func RR(grandfather:TreeNode, father: TreeNode, other: TreeNode):
	#MainScene.message("[color=yellow]RR ![/color]")
	#father.P = grandfather.P
	#if grandfather == _root:  # 重置根節點
		#_root = father
	#else:
		#if is_left_child(grandfather):
			#grandfather.P.L = father
		#else:
			#grandfather.P.R = father
	#grandfather.P = father
	#if other:
		#other.P = grandfather
	#grandfather.R = other
	#father.L = grandfather
	#father.P = null
	#father.color = BLACK
	#grandfather.color = RED
#


#endregion
