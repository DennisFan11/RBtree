class_name TreeHistory extends RefCounted

# 儲存每一步操作的狀態
class TreeState:
	var nodes: Array  # 儲存節點的值和顏色
	var connections: Array  # 儲存節點間的連接關係
	var message: String  # 操作的描述訊息
	
	func _init(tree_nodes: Array, tree_connections: Array, msg: String = ""):
		nodes = tree_nodes.duplicate(true)
		connections = tree_connections.duplicate(true)
		message = msg

# 歷史記錄
var history: Array[TreeState] = []
var current_index: int = -1

func save_state(tree_nodes: Array, tree_connections: Array, message: String = ""):
	# 如果我們在歷史中間做了新的操作，刪除之後的歷史
	if current_index < history.size() - 1:
		history = history.slice(0, current_index + 1)
	
	# 儲存新的狀態
	var new_state = TreeState.new(tree_nodes, tree_connections, message)
	history.append(new_state)
	current_index = history.size() - 1
	
	# 更新UI顯示
	MainScene.message("[color=green]State saved: %s[/color]" % message)

func can_undo() -> bool:
	return current_index > 0

func can_redo() -> bool:
	return current_index < history.size() - 1

func undo() -> Dictionary:
	if not can_undo():
		MainScene.message("[color=red]No more undo history![/color]")
		return {}
	
	current_index -= 1
	var state = history[current_index]
	MainScene.message("[color=yellow]Undo: %s[/color]" % state.message)
	
	return {
		"nodes": state.nodes,
		"connections": state.connections
	}

func redo() -> Dictionary:
	if not can_redo():
		MainScene.message("[color=red]No more redo history![/color]")
		return {}
	
	current_index += 1
	var state = history[current_index]
	MainScene.message("[color=yellow]Redo: %s[/color]" % state.message)
	
	return {
		"nodes": state.nodes,
		"connections": state.connections
	}

func clear_history():
	history.clear()
	current_index = -1
	MainScene.message("[color=yellow]History cleared[/color]")
