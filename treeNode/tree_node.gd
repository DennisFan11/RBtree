class_name TreeNode extends Node2D
enum {BLACK, RED, DOUBLE_BLACK}
var color:int
var val1:float:
	set(new):
		$Panel/Label.text = str(new)
		val1=new
var L:TreeNode
var R:TreeNode





#region 內部邏輯区域

func _get_self_point()-> Vector2: # 獲取節點位置
	return %SelfPoint.global_position
func _get_l_point()-> Vector2:
	return %LPoint.position
func _get_r_point()-> Vector2:
	return %RPoint.position


var _deepth:int
var _xid:int

@onready var _LL:Line2D = %LineL
@onready var _RR:Line2D = %LineR
var _color_map = {
	BLACK:Color.BLACK,
	RED:Color.RED,
	DOUBLE_BLACK:Color.GRAY
}
const H_SPACE = 60.0
const V_SPACE = 60.0
const LERP_SPEED = 5.5
func _process(delta: float) -> void:
	_visible_update()
	position = position.lerp( Vector2( H_SPACE*_xid, V_SPACE*_deepth ), LERP_SPEED*delta )
	if L:
		_LL.points = [_get_l_point(), to_local(L._get_self_point())]
		_LL.default_color = _color_map[L.color]
		
	if R:
		_RR.points = [_get_r_point(), to_local(R._get_self_point())]
		_RR.default_color = _color_map[R.color]

#endregion

func _visible_update():
	%TextureButton.disabled = !%TextureButton.is_hovered()

func _on_texture_button_button_down() -> void:
	MainScene.remove(val1)
