extends ScrollContainer

export var duration = 0.3
export var focus_duration = 0.1

var isDrag = false
var startPos = 0
var dragDir = 0


onready var grid: GridContainer = $grid


func _on_ScrollContainer_gui_input(event: InputEvent):
	if event is InputEventMouseButton && event.is_pressed():
		isDrag = true
		startPos = event.position.y
	if event is InputEventMouseButton && !event.is_pressed():
		isDrag = false
		startPos = 0
		is_scroll_out()

	if isDrag && grid.rect_size.y > rect_size.y:
		var offset = event.position.y - startPos
		if offset > 0:
			dragDir = 1
		elif offset < 0:
			dragDir = -1
		grid.rect_position.y = grid.rect_position.y + offset
		startPos = event.position.y


func is_scroll_out():
	if grid.rect_position.y > 0:
		global_var.dotween(
			grid,
			"rect_position",
			Vector2(grid.rect_position.x, grid.rect_position.y),
			Vector2.ZERO,
			duration)
	elif grid.rect_position.y < rect_size.y - grid.rect_size.y:
		global_var.dotween(
			grid,
			"rect_position",
			Vector2(grid.rect_position.x, grid.rect_position.y),
			Vector2(grid.rect_position.x, rect_size.y - grid.rect_size.y),
			duration)
	else:
		if dragDir > 0:
			var index = int(abs(grid.rect_position.y) / 293)
			print(index)
			global_var.dotween(
				grid,
				"rect_position",
				Vector2(grid.rect_position.x, grid.rect_position.y),
				Vector2(grid.rect_position.x, -293 * index),
				focus_duration)
		else:
			var index = int(abs(grid.rect_position.y) / 293) + 1
			print(index)
			global_var.dotween(
				grid,
				"rect_position",
				Vector2(grid.rect_position.x, grid.rect_position.y),
				Vector2(grid.rect_position.x, -293 * index),
				focus_duration)
