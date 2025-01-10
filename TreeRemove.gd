class_name TreeRemove extends TreeCRUD

var _root:TreeNode

func remove(val) -> TreeNode:
	if !_root:
		return null

	delete_child(_root, val)

	if _root:
		_root.color = BLACK
	return _root

func delete_child(p, data):
	if p.val > data:
		if p.L == null:
			return false
		return delete_child(p.L, data)
	elif p.val < data:
		if p.R == null:
			return false
		return delete_child(p.R, data)
	elif p.val == data:
		if p.R == null:
			delete_one_child(p)
			return true
		print(p.R.val)
		var smallest = get_smallest_child(p.R)
		var temp = p.val
		p.val = smallest.val
		smallest.val = temp
		delete_one_child(smallest)
		return true
	else:
		return false

func delete_one_child(p):
	#print(p.L.val, p.R.val)
	var child:TreeNode = p.L if p.L == null else p.R

	# 根節點且無子節點的情況
	if p.P == null and p.L == null and p.R == null:
		p = null
		_root = p
		return
#跟維基不一樣
	if child == null: 
		delete_case(p)
		_delete_treeNode(p)
		return
#到這裡
	# 根節點有一個子節點的情況
	if p.P == null:
		_delete_treeNode(p)
		child.P = null
		_root = child
		_root.color = BLACK
		return

	# 更新父節點的子節點引用
	if p.P.L == p:
		p.P.L = child
	else:
		p.P.R = child
	#跟維基不一樣
	if child:
		child.P = p.P
	#到這裡

	# 如果刪除的節點是黑色
	if p.color == BLACK:
		if child.color == RED:
			child.color = BLACK
		else:
			delete_case(p)

	_delete_treeNode(p)

func delete_case(p):
	if p.P == null:
		p.color = BLACK
		return
		
	if sibling(p).color == RED:
		MainScene.message("[color=yellow]1[/color]")
		p.P.color = RED
		sibling(p).color = BLACK
		if p == p.P.L:
			rotL(p.P)
		else:
			rotR(p.P)

	if p.P.color == BLACK and sibling(p).color == BLACK and \
		sibling(p).L.color == BLACK and sibling(p).R.color == BLACK:
		sibling(p).color = RED
		delete_case(p.P)
	elif p.P.color == RED and sibling(p).color == BLACK and \
			sibling(p).L.color == BLACK and sibling(p).R.color == BLACK:
		sibling(p).color = RED
		p.P.color = BLACK
	else:
		if sibling(p).color == BLACK:
			if p == p.P.L and sibling(p).L.color == RED and \
				sibling(p).R.color == BLACK:
				sibling(p).color = RED
				sibling(p).L.color = BLACK
				rotR(sibling(p).L)
			elif p == p.P.R and sibling(p).L.color == BLACK and \
					sibling(p).R.color == RED:
				sibling(p).color = RED
				sibling(p).R.color = BLACK
				rotL(sibling(p).R)

		sibling(p).color = p.P.color
		p.P.color = BLACK
		if p == p.P.L:
			sibling(p).R.color = BLACK
			rotL(sibling(p))
		else:
			sibling(p).L.color = BLACK
			rotR(sibling(p))


func get_smallest_child(p):
	if p.L == null:
		return p
	return get_smallest_child(p.L)

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

func sibling(p):
	if p.P.L == p:
		return p.P.R
	elif p.P.R == p:
		return p.P.L
