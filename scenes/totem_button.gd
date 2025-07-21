class_name TotemButton
extends Control

@export var totem : Totem

const TOTEM_DRAGGABLE = preload("res://scenes/totem_draggable.tscn")

@onready var totem_name_label: Label = $TotemName
@onready var texture_rect: TextureRect = $TextureRect
@onready var cancel_button: UICancelButton = %CancelButton

func _ready() -> void:
	totem_name_label.text = totem.name
	texture_rect.modulate = totem.modulation_color
	$TextureRect.texture = totem.base_texture


func _create_mouse_draggable():
	var mouse_draggable := TOTEM_DRAGGABLE.instantiate()
	mouse_draggable.totem = totem.duplicate() as Totem 
	mouse_draggable.draggable_deleted.connect(_on_draggable_deleted)
	get_tree().get_first_node_in_group("ui_layer").add_child(mouse_draggable)
	mouse_draggable.add_to_group("mouse_draggable")
	
	texture_rect.visible = false

func _gui_input(event: InputEvent) -> void:
	var is_left_mouse_pressed: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
	var is_right_mouse_released: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_RIGHT and
		event.is_released()
	)
	var has_mouse_draggable := get_tree().get_nodes_in_group("mouse_draggable").size() > 0
	
	if is_left_mouse_pressed and not has_mouse_draggable:
		_create_mouse_draggable()
	
	elif is_left_mouse_pressed and has_mouse_draggable:
		var first_draggable : TotemDraggable = get_tree().get_first_node_in_group("mouse_draggable")
		if first_draggable.totem.name != totem.name:
			first_draggable.delete()
			await first_draggable.tree_exited
			_create_mouse_draggable()
	
	elif is_right_mouse_released and has_mouse_draggable:
		get_tree().get_first_node_in_group("mouse_draggable").delete()


func _on_draggable_deleted() -> void:
	texture_rect.visible = true
