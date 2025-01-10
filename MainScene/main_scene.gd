class_name MainScene extends Node2D

#region 外部接口

func _ready() -> void:
	_main_scene = self
	_tree = %Tree
	_history = TreeHistory.new()
	# 綁定快捷鍵
	set_process_input(true)
	
	# 綁定按鈕事件
	%PreviousButton.pressed.connect(_on_previous_button_pressed)
	%NextButton.pressed.connect(_on_next_button_pressed)
	
	# 初始化按鈕狀態
	_update_history_buttons()

static var _tree:Node2D
static var _main_scene:MainScene

static func add_new_node(node:TreeNode)-> void: ## 新增節點
	_tree.add_child(node)

static func remove(val:float):
	_main_scene._remove(val)

static func message(bbtext:String)-> void:
	_main_scene._message(bbtext)

#endregion

#region 樹操作
var _root :TreeNode
var _history: TreeHistory

var _tree_insert:TreeInsert = TreeInsert.new()
var _tree_remove:TreeRemove = TreeRemove.new()

func _insert(val:float, batch:bool=false):
	_message("[color=green]Insert "+str(val)+"[/color]")
	_root = _tree_insert.insert(_root, val)
	_tree_update()
	
	# 總是保存狀態，但使用不同的描述
	if batch:
		_save_state("Batch Insert " + str(val))
	else:
		_save_state("Insert " + str(val))
		_message("[color=green]===== Insert Finish =====[/color]")

func _remove(val:float):
	_message("[color=red]Remove "+str(val)+"[/color]")
	_tree_remove._root = _root  # 設置當前根節點
	_root = _tree_remove.remove(val)  # 執行刪除操作
	_tree_update()
	_save_state("Remove " + str(val))
	_message("[color=red]===== Remove Finish =====[/color]")

func _save_state(message: String):
	var nodes = []
	var connections = []
	_collect_tree_state(_root, nodes, connections)
	_history.save_state(nodes, connections, message)
	_update_history_buttons()

func _update_history_buttons():
	if %PreviousButton and %NextButton:
		%PreviousButton.disabled = not _history.can_undo()
		%NextButton.disabled = not _history.can_redo()

func _collect_tree_state(node: TreeNode, nodes: Array, connections: Array):
	if !node:
		return
	
	# 儲存節點資訊
	nodes.append({
		"val": node.val,
		"color": node.color,
		"position": node.position,
		"parent_val": node.P.val if node.P else null  # 保存父節點的值
	})
	
	# 儲存連接資訊
	if node.L:
		connections.append({
			"from": node.val,
			"to": node.L.val,
			"type": "left",
			"color": node.L.color  # 保存連接線顏色
		})
		_collect_tree_state(node.L, nodes, connections)
	
	if node.R:
		connections.append({
			"from": node.val,
			"to": node.R.val,
			"type": "right",
			"color": node.R.color  # 保存連接線顏色
		})
		_collect_tree_state(node.R, nodes, connections)

func _restore_state(state: Dictionary):
	if state.is_empty():
		return
		
	# 清除當前樹
	for child in _tree.get_children():
		_tree.remove_child(child)
		child.queue_free()
	
	# 重建節點
	var nodes_dict = {}  # 用於快速查找節點
	_root = null  # 重置根節點
	
	# 第一步：創建所有節點
	for node_data in state["nodes"]:
		var node = TreeNode.create()  # 使用 create 方法創建節點
		node.val = node_data["val"]
		node.color = node_data["color"]
		node.position = node_data["position"]
		nodes_dict[node.val] = node
		_tree.add_child(node)
		
		# 如果沒有父節點，則這是根節點
		if node_data["parent_val"] == null:
			_root = node
	
	# 第二步：建立父子關係
	for node_data in state["nodes"]:
		var node = nodes_dict[node_data["val"]]
		if node_data["parent_val"] != null:
			node.P = nodes_dict[node_data["parent_val"]]
	
	# 第三步：建立連接
	for conn in state["connections"]:
		var from_node = nodes_dict[conn["from"]]
		var to_node = nodes_dict[conn["to"]]
		
		if conn["type"] == "left":
			from_node.L = to_node
		else:  # right
			from_node.R = to_node
			
		to_node.P = from_node
	
	# 更新樹的顯示
	_tree_update()

func _find_node(val: float) -> TreeNode:
	for child in _tree.get_children():
		if child is TreeNode and child.val == val:
			return child
	return null

func _input(event: InputEvent):
	if event.is_action_pressed("ui_undo"):  # Ctrl+Z
		_on_previous_button_pressed()
	elif event.is_action_pressed("ui_redo"):  # Ctrl+Y or Ctrl+Shift+Z
		_on_next_button_pressed()
	elif event.is_action_pressed("Enter"):
		_on_button_button_down()
	elif event.is_action_pressed("zoom_in"):
		%Camera2D.zoom *= 1.1
	elif event.is_action_pressed("zoom_out"):
		%Camera2D.zoom *= 0.9
	elif event.is_action_pressed("right_click"):
		_on_back_to_root_button_down()

func _on_previous_button_pressed():
	var state = _history.undo()
	_restore_state(state)
	_update_history_buttons()

func _on_next_button_pressed():
	var state = _history.redo()
	_restore_state(state)
	_update_history_buttons()

#endregion

#region 位置更新相關
func _tree_update():
	__xid = 0
	_deep_count(_root, 0)

var __xid:int
func _deep_count(node:TreeNode, last_deepth:int)-> int: ## 設定深度, xid
	if !node:
		return last_deepth
	var curr_deepth = last_deepth+1
	node._deepth = curr_deepth
	#print(node.val)
	if node.L and node.L is not FakeNode:
		_deep_count(node.L, curr_deepth)
	
	__xid += 1
	node._xid = __xid
	
	if node.R and node.R is not FakeNode:
		_deep_count(node.R, curr_deepth)
	return curr_deepth

#endregion

#region 攝影機
var _camera_pos  = Vector2.ZERO
var CAMERA_MOVE_SPEED:float = 500.0
const CAMERA_LERP_SPEED:float = 8.0
func _process(delta: float) -> void:
	_camera_pos += Input.get_vector("A", "D", "W", "S") * CAMERA_MOVE_SPEED * delta
	%Camera2D.offset = %Camera2D.offset.lerp(_camera_pos, CAMERA_LERP_SPEED * delta)
#endregion

#region Global message
var _message_arr = []
const MESSAGE_LIVE_TIME:float = 60.0
func _message(str:String):
	print_rich(str)
	
	var rich = RichTextLabel.new()
	rich.custom_minimum_size.y = 38.0
	rich.bbcode_enabled = true
	rich.text = str
	rich.mouse_filter = Control.MOUSE_FILTER_IGNORE
	%Messages.add_child(rich)
	
	var tween = get_tree().create_tween()
	tween.tween_property(rich, "modulate", Color(1.0, 1.0, 1.0, 0.0), MESSAGE_LIVE_TIME)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_callback(_message_arr.erase.bind(rich))
	tween.tween_callback(rich.queue_free)
	
	
	_message_arr.append(rich)
	if _message_arr.size() > 15:
		var node = _message_arr.pop_front()
		node.queue_free()

#endregion

#region GUI event

func _on_button_button_down() -> void: ## insert
	if %TextEdit.text == "":
		_insert(randi_range(0, 999))
		return 
	var val:float = %TextEdit.text.to_float()
	%TextEdit.text = ""
	_insert(val)

func _on_ll_button_down() -> void:
	if _history.history.is_empty():
		_save_state("Initial State")
	
	var values = [6, 7, 4, 5, 2, 3, 1]
	for i in values:
		_insert(i, true)
	
	_message("[color=green]Test Data: LL [/color]")

func _on_lr_button_down() -> void:
	if _history.history.is_empty():
		_save_state("Initial State")
	
	var values = [6, 2, 7, 1, 4, 3, 5]
	for i in values:
		_insert(i, true)
	
	_message("[color=green]Test Data: LR [/color]")

func _on_rl_button_down() -> void:
	if _history.history.is_empty():
		_save_state("Initial State")
	
	var values = [2, 1, 6, 4, 7, 3, 5]
	for i in values:
		_insert(i, true)
	
	_message("[color=green]Test Data: RL [/color]")

func _on_rr_button_down() -> void:
	if _history.history.is_empty():
		_save_state("Initial State")
	
	var values = [2, 1, 4, 3, 6, 5, 7]
	for i in values:
		_insert(i, true)
	
	_message("[color=green]Test Data: RR [/color]")

func _on_clear_button_button_down() -> void:
	_root = null
	for i in %Tree.get_children():
		i.queue_free()
	_save_state("Clear Tree")  # 保存清除狀態

func _on_random_10_button_button_down() -> void:
	if _history.history.is_empty():
		_save_state("Initial State")
	
	for i in range(10):
		var val = randi_range(0, 1000)
		_insert(val, true)
	
	_message("[color=green]Test Data: Random x10 [/color]")

func _on_random_100_button_button_down() -> void:
	if _history.history.is_empty():
		_save_state("Initial State")
	
	for i in range(100):
		var val = randi_range(0, 1000)
		_insert(val, true)
	
	_message("[color=green]Test Data: Random x100 [/color]")

func _on_test_button_button_down() -> void:
	if _history.history.is_empty():
		_save_state("Initial State")
	
	for i in range(100):
		_insert(i, true)
	
	_message("[color=green]Test Data: Sequential [/color]")

func _on_back_to_root_button_down() -> void:
	if _root:
		_camera_pos = _root.global_position + Vector2(0.0, 150.0)

#endregion

#region UndoRedo WARNING 未完成功能
#static var _u:UndoRedo 
#static func add_do(u:UndoRedo, root:TreeNode):
	#_u = u
	#if root:
		#if root.L:
			#add_do(u, root.L)
		#if root.R:
			#add_undo(u, root.R)
		#root.do(u)
#static func add_undo(u:UndoRedo, root:TreeNode):
	#_u = u
	#if root:
		#if root.L:
			#add_undo(u, root.L)
		#if root.R:
			#add_undo(u, root.R)
		#root.undo(u)
#endregion
