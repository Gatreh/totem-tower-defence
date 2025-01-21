#extends Area2D
#
#func _input_event(viewport: Viewport, event: InputEvent, shape_index: int) -> void:
	#var event_is_mouse_release : bool = (
		#event is InputEventMouseButton and
		#event.button_index == MOUSE_BUTTON_LEFT and
		#event.is_released()
	#)
	#var event_is_mouse_held : bool = (
		#event is InputEventMouseButton and
		#event.button_index == MOUSE_BUTTON_LEFT and
		#event.is_pressed()
	#)
	#
	#if event_is_mouse_release:
		#print("Mouse release")
		#var mpos = get_global_mouse_position().length()
		#print(mpos)
	#if event_is_mouse_held:
		#print("Mouse hold")
		#var mpos = get_global_mouse_position()
		#print(mpos)
