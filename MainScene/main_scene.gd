class_name MainScene extends Node2D

#region 外部接口
static var _tree:Node2D
static var _main_scene:MainScene

static func add_new_node(node:TreeNode)-> void: ## 新增節點
	_tree.add_child(node)

static func remove(val:float):
	_main_scene._remove(val)

static func message(bbtext:String)-> void:
	_main_scene._message(bbtext)
#endregion


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter"):
		_on_button_button_down()
	elif event.is_action_pressed("zoom_in"):
		%Camera2D.zoom *= 1.1
	elif event.is_action_pressed("zoom_out"):
		%Camera2D.zoom *= 0.9

func _on_button_button_down() -> void: ## insert
	if %TextEdit.text == "":
		_insert(randi_range(0, 99))
		return 
	var val:float = %TextEdit.text.to_float()
	%TextEdit.text = ""
	_insert(val)

func _ready() -> void:
	_main_scene = self
	_tree = %Tree

#region 樹操作
var _root :TreeNode

var _tree_insert:TreeInsert = TreeInsert.new()
var _tree_remove:TreeRemove = TreeRemove.new()

func _insert(val:float):
	_message("[color=green]Insert "+str(val)+"[/color]")
	_root = _tree_insert.insert(_root, val)
	_tree_update()

func _remove(val:float):
	_message("[color=red]Remove "+str(val)+"[/color]")
	_root = _tree_remove.remove(_root, val)
	_tree_update()
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
	if node.L:
		_deep_count(node.L, curr_deepth)
	
	__xid += 1
	node._xid = __xid
	
	if node.R:
		_deep_count(node.R, curr_deepth)
	return curr_deepth

#endregion

#region 攝影機
var _camera_pos  = Vector2.ZERO
const CAMERA_MOVE_SPEED:float = 500.0
const CAMERA_LERP_SPEED:float = 8.0
func _process(delta: float) -> void:
	_camera_pos += Input.get_vector("A", "D", "W", "S") * CAMERA_MOVE_SPEED * delta
	%Camera2D.offset = %Camera2D.offset.lerp(_camera_pos, CAMERA_LERP_SPEED * delta)
#endregion

#region Global message
var _message_arr = []
const MESSAGE_LIVE_TIME:float = 10.0
func _message(str:String):
	print_rich(str)
	
	var rich = RichTextLabel.new()
	rich.custom_minimum_size.y = 27.0
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
func _on_ll_button_down() -> void:
	for i in [6, 5, 3, 4, 2]: # LL 
		_insert(i)
	message("[color=green]Test Data: LL [/color]")

func _on_lr_button_down() -> void:
	for i in [5, 1, 3, 2, 4]: # LR
		_insert(i)
	message("[color=green]Test Data: LR [/color]")

func _on_rl_button_down() -> void:
	for i in [1, 5, 3, 4, 2]:
		_insert(i)
	message("[color=green]Test Data: RL [/color]")

func _on_rr_button_down() -> void:
	for i in [1, 2, 4, 3, 5]:
		_insert(i)
	message("[color=green]Test Data: RR [/color]")

func _on_clear_button_button_down() -> void:
	_root = null
	for i in %Tree.get_children():
		i.queue_free()
#endregion
