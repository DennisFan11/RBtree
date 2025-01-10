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
		var smallest = get_smallest_child(p.R)
		swap(p, smallest)
		delete_one_child(smallest)
		return true
	else:
		return false

func delete_one_child(p):
	var child:TreeNode = p.R if p.L == null else p.L

	# 根節點且無子節點的情況
	if p.P == null and p.L == null and p.R == null:
		p = null
		_root = p
		return
#跟維基不一樣
	if child == null:
		if get_color(p) == RED:
			_delete_treeNode(p)
			return
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
	if get_color(p) == BLACK:
		if get_color(child) == RED:
			child.color = BLACK
		else:
			pass
			delete_case(child)

	_delete_treeNode(p)

func delete_case(p):
	if p.P == null:
		p.color = BLACK
		return
		
	if is_instance_valid(sibling(p)) and get_color(sibling(p)) == RED:
		MainScene.message("[color=yellow]1[/color]")
		p.P.color = RED
		sibling(p).color = BLACK
		if p == p.P.L:
			rotL(p.P.R)
		else:
			rotR(p.P.L)

	if is_instance_valid(sibling(p)) and get_color(p.P) == BLACK and get_color(sibling(p)) == BLACK and \
		get_color(sibling(p).L) == BLACK and get_color(sibling(p).R) == BLACK:
		sibling(p).color = RED
		delete_case(p.P)
	elif get_color(p.P) == RED and get_color(sibling(p)) == BLACK and \
			get_color(sibling(p).L) == BLACK and get_color(sibling(p).R) == BLACK:
		sibling(p).color = RED
		p.P.color = BLACK
	else:
		if get_color(sibling(p)) == BLACK:
			if p == p.P.L and get_color(sibling(p).L) == RED and \
				get_color(sibling(p).R) == BLACK:
				sibling(p).color = RED
				sibling(p).L.color = BLACK
				rotR(sibling(p).L)
			elif p == p.P.R and get_color(sibling(p).L) == BLACK and \
					get_color(sibling(p).R) == RED:
				sibling(p).color = RED
				sibling(p).R.color = BLACK
				rotL(sibling(p).R)

		if sibling(p): sibling(p).color = p.P.color
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
	if !is_instance_valid(p):
		return null
	if p.P.L == p:
		return p.P.R
	elif p.P.R == p:
		return p.P.L

func swap(p, p2):
	var temp = p.val
	p.val = p2.val
	p2.val = temp

func get_color(p):
	if p == null:
		return BLACK
	else:
		return p.color
