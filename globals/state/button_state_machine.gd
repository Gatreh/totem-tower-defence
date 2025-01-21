class_name ButtonStateMachine
extends Node

@export var initial_state: ButtonState

var current_state: ButtonState
var states := {}

func init(totem_button: TotemButton) -> void:
	for child in get_children():
		if child is ButtonState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.totem_button = totem_button
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)


func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)


func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()


func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()


func _on_transition_requested(from: ButtonState, to: ButtonState.State) -> void:
	print("Transition from: " + str(from) + " to: " + str(to) + " requested")
	if from != current_state:
		return
	
	var new_state: ButtonState = states[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
