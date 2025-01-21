extends ButtonState


func enter() -> void:
	if not totem_button.is_node_ready():
		await totem_button.ready
	
	totem_button.reparent_requested.emit(totem_button)
	totem_button.totem_name = "BASE"
	totem_button.pivot_offset = Vector2.ZERO


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		totem_button.pivot_offset = totem_button.get_global_mouse_position() - totem_button.global_position
		transition_requested.emit(self, ButtonState.State.CLICKED)
