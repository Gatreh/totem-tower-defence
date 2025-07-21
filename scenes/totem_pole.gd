class_name TotemPole extends Node2D

signal stack_requested(totem_pole : TotemPole, totem_data: Totem)
 
const projectile_path : String = "res://scenes/projectiles/"

var attack_speed : float : set = set_attack_speed
var attack_range : int : set = set_attack_range
var attack_type : Totem.AttackType
var cost : int
var damage : int
var element : Global.Element
var gimmicks : Array[Global.Gimmick] = [Global.Gimmick.NONE]
var max_totem_size : int = 2
var totem_stack : Array[Totem]

# Move selection to global to have a reference to the totem easily and 
# swap out when selecting a different totem
var selected : bool = false 
var initial_outline_thickness : float = 3.0
var hover_outline_thickness : float = initial_outline_thickness * 2

var _sprite_displacement : int = -38
var _targets : Array

@onready var attack_area: Area2D = $AttackArea
@onready var attack_range_area: CollisionShape2D = $AttackArea/Range
@onready var attack_timer: Timer = $AttackTimer
@onready var stack_area: Area2D = $StackArea
@onready var stack_area_shape: CollisionShape2D = %StackAreaShape

func _ready() -> void:
	stack_area.mouse_entered.connect(_on_mouse_entered)
	stack_area.mouse_exited.connect(_on_mouse_exited)
	stack_area.input_event.connect(_on_input_event)
	attack_area.area_entered.connect(_on_attack_range_area_entered)
	attack_area.area_exited.connect(_on_attack_range_area_exited)


func _physics_process(_delta: float) -> void:
	if _targets.is_empty():
		return
	if attack_timer.is_stopped():
		shoot(_targets)
		attack_timer.start()


## This function adds a totem section to the totem pole and updates the totem pole structure and stats.
func add_totem_section(section: Totem) -> void:
	totem_stack.append(section)
	update_totem_pole()
	update_attack_area_collision()
	generate_totem_sprite(section, totem_stack.size() - 1)


func generate_totem_sprite(totem : Totem, index: int) -> void:
	var sprite = Sprite2D.new()
	sprite.texture = totem.base_texture
	sprite.modulate = totem.modulation_color
	sprite.position.y = _sprite_displacement * index
	sprite.scale *= 0.4
	$CanvasGroup.add_child(sprite)


func shoot(targets : Array) -> void:
	var bullet_amount: int = 1
	var bullet_scene : Bullet
	var bullets : Array[Bullet]
	
	if attack_type == Totem.AttackType.CHAIN:
		bullet_scene = preload(projectile_path + "chain_attack.tscn").instantiate()
		bullet_scene.jumps = 3
		bullets.append(bullet_scene)
	
	if attack_type == Totem.AttackType.FLURRY:
		bullet_amount = 3
		for n in bullet_amount:
			bullet_scene = preload(projectile_path + "flurry_bullet.tscn").instantiate()
			bullet_scene.velocity = Vector2(randi_range(-500, 500), randi_range(-500, 500))
			bullet_scene.steering_factor = 2.0
			bullets.append(bullet_scene)
	
	if attack_type == Totem.AttackType.QUAKE:
		bullet_scene = preload(projectile_path + "quake_area.tscn").instantiate()
		bullet_scene.attack_range = attack_range
		bullets.append(bullet_scene)
	
	if attack_type == Totem.AttackType.SNIPE:
		bullet_scene = preload(projectile_path + "snipe_bullet.tscn").instantiate()
		bullets.append(bullet_scene)
	
	if attack_type == Totem.AttackType.STRIKE:
		bullet_scene = preload(projectile_path + "strike_bullet.tscn").instantiate()
		bullet_scene.travel_speed = 10000.0
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


func update_attack_area_collision() -> void:
	stack_area_shape.position.y += floor(float(_sprite_displacement) / 2) 
	stack_area_shape.shape.height -= _sprite_displacement
	stack_area_shape.shape.radius = 40


func update_totem_pole() -> void:
	for totem_index in totem_stack.size():
		match totem_index:
			0: # totem_index 0 adds the basic stats and attack type
				cost = totem_stack[totem_index].base_cost
				damage = totem_stack[totem_index].base_damage
				attack_speed = totem_stack[totem_index].base_attack_speed
				attack_range = totem_stack[totem_index].base_range
				attack_type = totem_stack[totem_index].attack_type
			
			1: # totem_index 1 upgrades the stats and adds the element and gimmick to the tower
				cost = floor(float(cost) * totem_stack[totem_index].cost_multiplier)
				damage = floor(float(damage) * totem_stack[totem_index].damage_multiplier)
				attack_speed = attack_speed * totem_stack[totem_index].attack_speed_multiplier
				attack_range = floor(float(attack_range) * totem_stack[totem_index].range_multiplier)
				element = totem_stack[totem_index].element as Global.Element
				
				# Add collision layer based on gimmick
				attack_area.set_collision_mask_value(totem_stack[totem_index].gimmick, true)
				gimmicks.append(totem_stack[totem_index].gimmick)
			
			2: # totem_index 2 upgrades the stats again, creates combination elements and adds a second gimmick
				pass


func set_attack_range(new_range: int) -> void:
	attack_range = new_range
	attack_range_area.shape.radius = attack_range


func set_attack_speed(new_attack_speed: float) -> void:
	attack_speed = new_attack_speed
	attack_timer.wait_time = 1 / attack_speed


func set_outline_thickness(new_thickness: float) -> void:
	$CanvasGroup.material.set_shader_parameter("line_thickness", new_thickness)


func set_outline_color(new_color: Color) -> void:
	$CanvasGroup.material.set_shader_parameter("line_color", new_color)


func _on_attack_range_area_entered(area: Area2D) -> void:
	if area is Enemy:
		_targets.append(area)
		_sort_targets()


func _sort_targets() -> void:
	_targets.sort_custom(func(a, b): return a.path_follow_2d.progress > b.path_follow_2d.progress)


func _on_attack_range_area_exited(area: Area2D) -> void:
	_targets.erase(area)


func _on_input_event(_viewport: Viewport, event: InputEvent, _idx: int) -> void:
	var event_is_mouse_release: bool = (
			event is InputEventMouseButton and
			event.button_index == MOUSE_BUTTON_LEFT and
			event.is_released()
	)
	
	var has_mouse_draggable := get_tree().get_nodes_in_group("mouse_draggable").size() > 0
	
	if event_is_mouse_release and has_mouse_draggable and totem_stack.size() < max_totem_size:
		stack_requested.emit(self, get_tree().get_first_node_in_group("mouse_draggable").totem)
	
	elif event_is_mouse_release and has_mouse_draggable and totem_stack.size() == max_totem_size:
		# show that max stack size has been reached
		pass
	
	elif event_is_mouse_release and not has_mouse_draggable:
		var parameters := PhysicsPointQueryParameters2D.new()
		parameters.position = event.position
		parameters.collide_with_areas = true
		parameters.collision_mask = 1 << 14 # bitwise operator, move it by 15 positions, resulting in 16384.
		
		var objects_clicked = get_world_2d()\
							.direct_space_state\
							.intersect_point(parameters)\
							.map(func(dict): return dict.collider)
		objects_clicked.sort_custom(func(a, b): return a.global_position.y > b.global_position.y)
		
		if stack_area == objects_clicked[0]:
			set_outline_color(Color.BLACK if selected else Color.WHITE)
			selected = not selected
			# Show tooltip window


func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_method(set_outline_thickness, initial_outline_thickness, hover_outline_thickness, 0.08)


func _on_mouse_exited() -> void:
	selected = false
	set_outline_color(Color.BLACK)
	var tween = create_tween()
	tween.tween_method(set_outline_thickness, hover_outline_thickness, initial_outline_thickness, 0.08)
