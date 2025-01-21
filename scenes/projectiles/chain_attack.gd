extends Bullet

var jumps : int = 3
var initial_jumps : int
var targets : Array[Enemy]
var has_dealt_damage : bool = false

func _ready() -> void:
	initial_jumps = jumps
	targets.append(target)
	
	area_entered.connect(_on_area_entered)
	$Sprite2D.modulate = modulation_color


func _physics_process(delta: float) -> void:
	# Make sure there actually exists a target. Otherwise free the bullet.
	if targets == null or targets.is_empty() or target == null or not is_instance_valid(target):
		queue_free()
		return
	
	var direction = global_position.direction_to(target.global_position)
	position += direction * travel_speed * delta
	
	if global_position.distance_to(target.global_position) < 30 and not has_dealt_damage:
		if target.has_method("take_damage"):
			target.take_damage(calculate_damage(), element)
			has_dealt_damage = true
			targets.erase(target)
			
			if not targets.is_empty():
				target = targets.front()
				has_dealt_damage = false
			else:
				queue_free()
				return
		jumps -= 1
		if jumps == 0:
			queue_free()


func calculate_damage() -> int:
	# first time it jumps it does 100% damage, the last time it jumps it does 50% damage
	# It always does 50% damage, then depending on how many jumps are left it adds up to 50% more damage
	return (damage * 0.5) + (damage * 0.5 * (float(jumps) / initial_jumps if jumps > 1 else 0))


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy and not targets.has(area):
		targets.append(area as Enemy)
		
