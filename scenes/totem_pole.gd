class_name TotemPole extends Node2D

@export var totem_stack : Array[Totem]

var damage : int
var attack_speed: float : set = set_attack_speed
var range : int : set = set_attack_range
var attack_type : Totem.AttackType
var element : Global.Element
var gimmicks : Array[Global.Gimmick] = [Global.Gimmick.NONE]
var max_totem_size : int = 2

var _sprite_displacement : int = -38
var _targets : Array

@onready var stack_area: Area2D = $StackArea
@onready var attack_area: Area2D = $AttackArea
@onready var attack_range: CollisionShape2D = $AttackArea/Range
@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	stack_area.input_event.connect(_on_input_event)
	attack_area.area_entered.connect(_on_attack_range_entered)
	attack_area.area_exited.connect(_on_attack_range_exited)


func _physics_process(delta: float) -> void:
	if _targets.is_empty():
		return
	if attack_timer.is_stopped():
		shoot(_targets)
		attack_timer.start()


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
	sprite.scale *= 0.4
	add_child(sprite)


func shoot(targets : Array) -> void:
	var bullet_amount: int = 1
	var bullet_scene : Bullet
	var bullets : Array[Bullet]
	
	if attack_type == Totem.AttackType.CHAIN:
		bullet_scene = preload("res://scenes/projectiles/chain_attack.tscn").instantiate()
		bullet_scene.jumps = 3
		bullets.append(bullet_scene)
	
	if attack_type == Totem.AttackType.FLURRY:
		bullet_amount = 3
		for n in bullet_amount:
			bullet_scene = preload("res://scenes/projectiles/snipe_bullet.tscn").instantiate()
			bullet_scene.global_position += Vector2(randi_range(-20, 20), randi_range(-20, 20))
			bullets.append(bullet_scene)
	
	if attack_type == Totem.AttackType.QUAKE:
		bullet_scene = preload("res://scenes/projectiles/quake_area.tscn").instantiate()
		bullet_scene.range = range
		bullets.append(bullet_scene)
	
	if attack_type == Totem.AttackType.SNIPE:
		bullet_scene = preload("res://scenes/projectiles/snipe_bullet.tscn").instantiate()
		bullets.append(bullet_scene)
	
	if attack_type == Totem.AttackType.STRIKE:
		bullet_scene = preload("res://scenes/projectiles/strike_bullet.tscn").instantiate()
		# Get target position
		bullet_scene.global_position = targets.front().global_position - self.global_position + Vector2(0, -1080)
		bullets.append(bullet_scene)
	
	for bullet in bullets:
		bullet.target = targets.front() as Enemy
		bullet.damage = damage
		bullet.element = element
		if totem_stack.size() > 1:
			bullet.modulation_color = totem_stack[1].modulation_color
		else:
			bullet.modulation_color = Color.WEB_GRAY
		for gimmick in gimmicks:
			bullet.set_collision_mask_value(gimmick, true)
		
		#get_tree().root.get_node("Level").add_child(bullet)
		add_child(bullet)
		await get_tree().create_timer((1 / attack_speed) / bullet_amount * 0.18).timeout


func update_totem_pole():
	for totem_index in totem_stack.size():
		match totem_index:
			0: # totem_index 0 adds the basic stats and attack type
				damage = totem_stack[totem_index].base_damage
				attack_speed = totem_stack[totem_index].base_attack_speed
				range = totem_stack[totem_index].base_range
				attack_type = totem_stack[totem_index].attack_type
			
			1: # totem_index 1 upgrades the stats and adds the element and gimmick to the tower
				damage *= totem_stack[totem_index].damage_multiplier
				attack_speed *= totem_stack[totem_index].attack_speed_multiplier
				range *= totem_stack[totem_index].range_multiplier
				element = totem_stack[totem_index].element
				
				# Add collision layer based on gimmick
				attack_area.set_collision_mask_value(totem_stack[totem_index].gimmick, true)
				gimmicks.append(totem_stack[totem_index].gimmick)
			
			2: # totem_index 2 upgrades the stats again, creates combination elements and adds a second gimmick
				pass
		# Create a Sprite2D, add the current totems texture and coloration to it and displace it. 
		# Then add it as a child.
		# Displace the totem placement shape to be at the top of the newly added sprite
		# If it's a stack of 3, remove the ability to place more totems


func set_attack_range(new_range: int) -> void:
	range = new_range
	attack_range.shape.radius = range


func set_attack_speed(new_attack_speed: float) -> void:
	attack_speed = new_attack_speed
	attack_timer.wait_time = 1 / attack_speed


func _on_attack_range_entered(area: Area2D) -> void:
	if area is Enemy:
		_targets.append(area)


func _on_attack_range_exited(area: Area2D) -> void:
	_targets.remove_at(_targets.find(area))


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
