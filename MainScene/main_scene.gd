extends Node2D

func add_new_node(node:TreeNode):
	$TargetNode.add_child(node)
	
var _root :TreeNode
@onready var treeCRUD = TreeCRUD.new()

func _on_button_button_down() -> void:
	var val:float = %TextEdit.text.to_float()
	_root = treeCRUD.insert(_root, val)




func _process(delta: float) -> void:
	_update(_root, $TargetNode.position)

const LEN:float = 30.0
func _update(node:TreeNode, pos:Vector2):
	if !node:
		return 
	node.position = (node.position - pos).normalized()*LEN+pos
	for c in node.get_tree_nodes():
		_update(c, node.position)











#
