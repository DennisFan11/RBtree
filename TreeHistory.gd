class_name TreeHistory extends RefCounted

## 歷史記錄項目
class HistoryItem:
	var nodes: Array  # 儲存節點狀態
	var connections: Array  # 儲存連接狀態
	var description: String  # 操作描述
	
	func _init(nodes_state: Array, connections_state: Array, desc: String):
		nodes = nodes_state
		connections = connections_state
		description = desc

var _history: Array[HistoryItem] = []  # 歷史記錄列表
var _current_index: int = -1  # 當前狀態索引

## 儲存一個歷史記錄
func save_state(nodes: Array, connections: Array, description: String) -> void:
	# 如果當前不在最新狀態，刪除後面的歷史
	if _current_index < _history.size() - 1:
		_history = _history.slice(0, _current_index + 1)
	
	# 新增狀態
	_history.append(HistoryItem.new(nodes, connections, description))
	_current_index = _history.size() - 1

## 回到上一個狀態
func undo() -> Dictionary:
	if can_undo():
		_current_index -= 1
		var item = _history[_current_index]
		return {
			"nodes": item.nodes,
			"connections": item.connections
		}
	return {}

## 前往下一個狀態
func redo() -> Dictionary:
	if can_redo():
		_current_index += 1
		var item = _history[_current_index]
		return {
			"nodes": item.nodes,
			"connections": item.connections
		}
	return {}

## 檢查是否可以回到上一個狀態
func can_undo() -> bool:
	return _current_index > 0

## 檢查是否可以前往下一個狀態
func can_redo() -> bool:
	return _current_index < _history.size() - 1

## 獲取當前狀態的描述
func get_current_description() -> String:
	if _current_index >= 0 and _current_index < _history.size():
		return _history[_current_index].description
	return ""

## 清除所有歷史記錄
func clear() -> void:
	_history.clear()
	_current_index = -1
