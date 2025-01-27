extends Node

const TOTEM_POLE_SCENE = preload("res://scenes/totem_pole.tscn")

@onready var totem_poles: Node2D = %TotemPoles
@onready var placement_area: PlacementArea = %PlacementArea

func _ready() -> void:
	placement_area.valid_position.connect(_on_valid_position)


func can_afford_then_purchase(cost : int) -> bool:
	if Global.shells < cost:
		# show insufficient shells message
		return false
	else:
		Global.shells -= cost
		return true


func clean_up_draggable() -> void:
	get_tree().get_first_node_in_group("mouse_draggable").delete()


func _on_valid_position(position: Vector2, totem_data: Totem) -> void:
	if can_afford_then_purchase(totem_data.base_cost):
		var new_totem_pole := TOTEM_POLE_SCENE.instantiate()
		totem_poles.add_child(new_totem_pole)
		new_totem_pole.global_position = position
		new_totem_pole.add_totem_section(totem_data)
		new_totem_pole.stack_requested.connect(_totem_stack_update)
		
		# Clean up the draggable and cancel button
		clean_up_draggable()


func _totem_stack_update(totem_pole: TotemPole, totem_data: Totem) -> void:
	if can_afford_then_purchase(totem_data.costs[totem_pole.totem_stack.size()]):
		totem_pole.add_totem_section(totem_data)
		
		# Clean up the draggable and cancel button
		clean_up_draggable()
