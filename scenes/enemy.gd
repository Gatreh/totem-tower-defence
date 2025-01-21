class_name Enemy extends Area2D

var max_health : int
var health : int = max_health : set = set_health

func set_health(new_health: int) -> void:
	health = clampi(new_health, 0, max_health)
	if health == 0:
		queue_free()
