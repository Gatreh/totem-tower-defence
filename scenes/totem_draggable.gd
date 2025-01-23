class_name TotemDraggable extends Sprite2D

var totem : Totem
var original_owner : TotemButton

func _ready() -> void:
	texture = totem.base_texture
	modulate = totem.modulation_color


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	var is_right_mouse_button : bool = (
		event is InputEventMouseButton and 
		event.button_index == MOUSE_BUTTON_RIGHT and 
		event.is_pressed() 
	)
	
	if is_right_mouse_button:
		original_owner.texture_rect.visible = true
		queue_free()
