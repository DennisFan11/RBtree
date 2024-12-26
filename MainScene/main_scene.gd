class_name MainScene extends Node2D

static func add_new_node(node:TreeNode):
	_tree.add_child(node)
	
var _root :TreeNode
@onready var treeCRUD = TreeCRUD.new()

func _on_button_button_down() -> void:
	var val:float = %TextEdit.text.to_float()
	_root = treeCRUD.insert(_root, val)

func _ready() -> void:
	_tree = %Tree

static var _tree
func _process(delta: float) -> void:
	#print(_root)
	_update(_root, %Target.position)



const LEN:float = 160.0
const G = 10.0
func _update(node:TreeNode, pos:Vector2):
	if !node:
		return 
	node.position.y += G
	node.position = (node.position - pos).limit_length(LEN)+pos
	for c in node.get_tree_nodes():
		_update(c, node.position)











#
