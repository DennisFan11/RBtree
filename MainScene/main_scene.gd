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
	var val:float = %TextEdit.text.to_float()
	%TextEdit.text = ""
	_insert(val)

func _ready() -> void:
	_main_scene = self
	_tree = %Tree
	for i in [5, 4, 6, 3, 7, 2, 8, 1, 9]:
		_insert(i)


#region 樹操作
var _root :TreeNode
@onready var treeCRUD = TreeCRUD.new()
func _insert(val:float):
	_message("[color=green]Insert "+str(val)+"[/color]")
	_root = treeCRUD.insert(_root, val)
	_tree_update()

func _remove(val:float):
	_message("[color=red]Remove "+str(val)+"[/color]")
	treeCRUD.remove(_root, val)
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
const MESSAGE_LIVE_TIME:float = 5.0
func _message(str:String):
	
	var rich = RichTextLabel.new()
	rich.custom_minimum_size.y = 27.0
	rich.bbcode_enabled = true
	rich.text = str
	%Messages.add_child(rich)
	
	var tween = get_tree().create_tween()
	tween.tween_property(rich, "modulate", Color(1.0, 1.0, 1.0, 0.0), MESSAGE_LIVE_TIME)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_callback(rich.queue_free)


#endregion




#
