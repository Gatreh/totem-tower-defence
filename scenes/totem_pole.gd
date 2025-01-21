class_name TotemPole extends Node2D

@export var totem_stack : Array[Totem]

var damage : int
var attack_speed: float
var range : int : set = set_attack_range
var attack_type : Totem.AttackType
var element : Global.Element
var max_totem_size : int = 2

var _sprite_displacement : int = -95
var _targets : Array

@onready var stack_area: Area2D = $StackArea
@onready var attack_area: Area2D = $AttackArea
@onready var attack_range: CollisionShape2D = $AttackArea/Range

func _ready() -> void:
	stack_area.input_event.connect(_on_input_event)


func _physics_process(delta: float) -> void:
	if _targets.is_empty():
		return


## This function adds a totem section to the totem pole and updates the totem pole structure and stats.
func add_totem_section(section: Totem):
	totem_stack.append(section)
	update_totem_pole()
	generate_totem_sprite(section, totem_stack.size() - 1)


func generate_totem_sprite(totem : Totem, index: int) -> void:
	var sprite = Sprite2D.new()
	sprite.texture = totem.base_texture
	sprite.modulate = totem.modulation_color
	sprite.position.y = _sprite_displacement * index
	add_child(sprite)


func update_totem_pole():
	for totem_index in totem_stack.size():
		match totem_index:
			0: # totem_index 0 adds the basic stats and attack type
				damage = totem_stack[totem_index].base_damage
				attack_speed = totem_stack[totem_index].base_attack_speed
				range = totem_stack[totem_index].base_range
				attack_type = totem_stack[totem_index].attack_type
			1: # totem_index 1 ads the element and gimmick to the tower
				damage *= totem_stack[totem_index].damage_multiplier
				attack_speed *= totem_stack[totem_index].attack_speed_multiplier
				range *= totem_stack[totem_index].range_multiplier
				element = totem_stack[totem_index].element
				#add collision shape based on gimmick.
				attack_area.set_collision_layer_value(totem_stack[totem_index].gimmick, true)
			2: # totem_index 2 creates combination elements and adds a second gimmick
				pass
		# Create a Sprite2D, add the current totems texture and coloration to it and displace it. 
		# Then add it as a child.
		# Displace the totem placement shape to be at the top of the newly added sprite
		# If it's a stack of 3, remove the ability to place more totems


func set_attack_range(new_range: int) -> void:
	range = new_range
	attack_range.shape.radius = range


func _on_input_event(_viewport: Viewport, event: InputEvent, _idx: int) -> void:
	var event_is_mouse_release: bool = (
			event is InputEventMouseButton and
			event.button_index == MOUSE_BUTTON_LEFT and
			event.is_released()
	)
	var has_mouse_draggable := get_tree().get_nodes_in_group("mouse_draggable").size() > 0
	
	if has_mouse_draggable and event_is_mouse_release and totem_stack.size() < max_totem_size:
		var first_draggable : TotemDraggable = get_tree().get_first_node_in_group("mouse_draggable")
		add_totem_section(first_draggable.totem)
		
		# Clean up draggable component
		first_draggable.original_owner.texture_rect.visible = true
		first_draggable.remove_from_group("mouse_draggable")
		first_draggable.queue_free()
