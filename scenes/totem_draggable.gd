class_name TotemDraggable extends Sprite2D

signal draggable_deleted

var totem : Totem

@onready var cancel_button = get_parent().get_node("InGameUI/%CancelButton") as UICancelButton

func _ready() -> void:
	texture = totem.base_texture
	modulate = totem.modulation_color
	cancel_button.toggle_visibilty(true)


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position() + (texture.get_size() * (scale / 2))


func _unhandled_input(event: InputEvent) -> void:
	var is_right_mouse_button : bool = (
		event is InputEventMouseButton and 
		event.button_index == MOUSE_BUTTON_RIGHT and 
		event.is_pressed() 
	)
	
	if is_right_mouse_button:
		delete()


func delete() -> void:
	cancel_button.toggle_visibilty(false) 
	draggable_deleted.emit()
	remove_from_group("totem_draggable")
	queue_free()
