class_name ButtonState
extends Node

enum State {
	BASE,
	CLICKED,
	DRAGGING,
	AIMING,
	RELEASED,
}

signal transition_requested(from: ButtonState, to:  State)

@export var state : State
var totem_button : TotemButton
var totem : Totem

func enter() -> void:
	pass


func exit() -> void:
	pass


func on_input(_event:InputEvent) -> void:
	pass


func on_gui_input(_event:InputEvent) -> void:
	pass

func on_mouse_entered() -> void:
	pass


func on_mouse_exited() -> void:
	pass
