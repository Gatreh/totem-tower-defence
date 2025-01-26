class_name PlacementArea extends Area2D

const TOTEM_POLE = preload("res://scenes/totem_pole.tscn")
@onready var in_game_ui: Control = %InGameUI


func _ready() -> void:
	input_event.connect(_on_input_event)


func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_index: int) -> void:
	var event_is_mouse_release: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_released()
	)
	
	var has_mouse_draggable := get_tree().get_nodes_in_group("mouse_draggable").size() > 0
	
	if event_is_mouse_release and has_mouse_draggable:
		var parameters := PhysicsPointQueryParameters2D.new()
		parameters.position = event.position
		parameters.collide_with_areas = true
		parameters.collision_mask = 1 << 15 # bitwise operator, move it by 15 positions, resulting in 32768.
		
		var objects_clicked = get_world_2d()\
							.direct_space_state\
							.intersect_point(parameters)\
							.map(func(dict): return dict.collider)
		
		if objects_clicked.size() == 1:
			# If you clicked on only one area then create a new totem pole at that location
			var first_draggable : TotemDraggable = get_tree().get_first_node_in_group("mouse_draggable")
			
			# If you can't afford it then abort, else deduct cost.
			if Global.shells < first_draggable.totem.base_cost:
				return
			Global.shells -= first_draggable.totem.base_cost
			
			var new_totem_pole := TOTEM_POLE.instantiate()
			%TotemPoles.add_child(new_totem_pole)
			new_totem_pole.global_position = event.global_position
			new_totem_pole.add_totem_section(first_draggable.totem)
			
			# Clean up the draggable and cancel button
			first_draggable.delete()
