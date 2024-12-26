class_name TreeNode extends Node2D
var val1:float:
	set(new):
		$Panel/Label.text = str(new)
		val1=new
var val2:float:
	set(new):
		$Panel/Label2.text = str(new)
		val1=new
var val3:float:
	set(new):
		$Panel/Label3.text = str(new)
		val1=new
var L:TreeNode
var LC:TreeNode
var RC:TreeNode
var R:TreeNode

var _LL:Line2D
var _RR:Line2D
func _ready() -> void:
	_LL = Line2D.new()
	MainScene._tree.add_child(_LL)
	_RR = Line2D.new()
	MainScene._tree.add_child(_RR)

const _R = 60.0
func _process(delta: float) -> void:
	for i in $Area2D.get_overlapping_areas():
		var dist = (position - i.get_parent().position).length()
		dist = _R-dist
		position += (position - i.get_parent().position).normalized()*dist/2.0

	if L:
		_LL.points = [position, L.position]
	if R:
		_RR.points = [position, R.position]

func get_tree_nodes()-> Array[TreeNode]:
	return [L, LC, RC, R]
