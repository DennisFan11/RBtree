class_name TreeNode extends Node2D
enum {BLACK, RED, DOUBLE_BLACK}
var color:int:
	set(new): _color = new
	get: return _get_color()
var _color:int
func _get_color():
	return _color


var _val:float
var val:float:
	set(new):
		_val = new
		if is_node_ready() and $Panel/Label:  # 確保節點已準備好且 Label 存在
			$Panel/Label.text = str(new)
	get:
		return _val

var P:TreeNode: # 父節點
	set(new):
		P = new
var L:TreeNode: # 節點
	set(new):
		L = new
		#if new: new.P = self
var R:TreeNode: # 節點
	set(new):
		R = new
		#if new: new.P = self
var PP:TreeNode:
	get:
		return P.P if P else null

var _deepth:int
var _xid:int

@onready var _LL:Line2D = %LineL
@onready var _RR:Line2D = %LineR
var _color_map = {
	BLACK:Color.BLACK,
	RED:Color.RED,
	DOUBLE_BLACK:Color.GRAY
}
const H_SPACE = 30.0 # 60
const V_SPACE = 60.0
const LERP_SPEED = 5.5

static func create() -> TreeNode:
	# 載入場景
	var scene = load("res://treeNode/treeNode.tscn")
	return scene.instantiate()


func _get_self_point()-> Vector2:
	return %SelfPoint.global_position

func _get_l_point()-> Vector2:
	return %LPoint.position

func _get_r_point()-> Vector2:
	return %RPoint.position

func _process(delta: float) -> void:
	if not is_node_ready():
		return
		
	_visible_update()
	position = position.lerp(Vector2(H_SPACE*_xid, V_SPACE*_deepth), LERP_SPEED*delta)
	if is_instance_valid(L) and L is not FakeNode:
		_LL.points = [_get_l_point(), to_local(L._get_self_point())]
		_LL.default_color = _color_map[L.color]
	else:
		_LL.points = []
		
	if is_instance_valid(R) and R is not FakeNode:
		_RR.points = [_get_r_point(), to_local(R._get_self_point())]
		_RR.default_color = _color_map[R.color]
	else:
		_RR.points = []

func _visible_update():
	if not is_node_ready() or not %TextureButton:
		return
	%TextureButton.disabled = !%TextureButton.is_hovered()

func _on_texture_button_button_down() -> void:
	MainScene.remove(val)

func _ready():
	if _val != 0:  # 如果值已經設置，更新 Label
		$Panel/Label.text = str(_val)
