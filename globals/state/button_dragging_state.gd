extends ButtonState

var valid_position := false

func enter() -> void:
	var position_check : PlacementArea = get_tree().get_first_node_in_group("placement_area")
	position_check.valid_position.connect(get_valid_position)
	totem_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		totem_button.reparent(ui_layer)
	
	totem_button.totem_name = "DRAGGING"


func on_input(event: InputEvent) -> void:
	var is_left_mouse: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and 
		(event.is_pressed() or event.is_released())
	)
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = is_left_mouse
	
	if mouse_motion:
		totem_button.global_position = totem_button.get_global_mouse_position() - totem_button.pivot_offset
	
	if cancel:
		transition_requested.emit(self, ButtonState.State.BASE)
	elif confirm and valid_position:
		transition_requested.emit(self, ButtonState.State.RELEASED)
