class_name TreeInsert extends TreeCRUD

#region insert

func insert(root:TreeNode, insert_val:float)-> TreeNode:
	_root = root
	var new_node = _insert_BST(root, insert_val)
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

func _fix_insert(node:TreeNode)-> void:
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

	if y:
		y.P = fa
	fa.R = y
	
	P.L = fa
	fa.P = P

	if gp:
		if gp.L == fa:
			gp.L = P
		else:
			gp.R = P
	P.P = gp
	
	if _root == fa:
		_root = P


func rotR(P:TreeNode):
	MainScene.message("[color=yellow]R rotate ![/color]")
	var gp:TreeNode = P.PP
	var fa:TreeNode = P.P
	var y:TreeNode = P.R

	if y:
		y.P = fa
	fa.L = y
	
	P.R = fa
	fa.P = P

	if gp:
		if gp.L == fa:
			gp.L = P
		else:
			gp.R = P
	P.P = gp
	
	if _root == fa:
		_root = P

#endregion
