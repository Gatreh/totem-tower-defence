extends ButtonState


func enter() -> void:
	totem_button.totem_name = "CLICKED"
	totem_button.drop_point_detector.monitoring = true


func on_input(event: InputEvent) -> void:
	var is_left_mouse_released:bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_released()
	)
	if event is InputEventMouseMotion or is_left_mouse_released:
		transition_requested.emit(self, ButtonState.State.DRAGGING)
