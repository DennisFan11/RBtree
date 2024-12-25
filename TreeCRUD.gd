class_name TreeCRUD extends RefCounted

#region interface NOTE 函數簽名簿不允許更動

## 回傳new root
func insert(root:TreeNode, insert_val:float)-> TreeNode:
	if !root:
		var node = _make_treeNode()
		node.val1 = insert_val
		return node
	return null

## 回傳new root
func remove(root:TreeNode, remove_val:float)-> TreeNode:
	return null

#endregion


#dawdawd
## TODO 實作2,3,4,樹



func _make_treeNode()-> TreeNode:
	var node = TreeNode.new()
	MainScene.add_new_node(node)
	return node

func _delete_treeNode(node:TreeNode):
	node.queue_free()













#
