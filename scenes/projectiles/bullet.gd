class_name Bullet extends Area2D

var damage : int
var target : Enemy
var element : Global.Element
var modulation_color : Color
var travel_speed : float = 3000.0
var velocity : Vector2 = Vector2.ZERO
var steering_factor : float = 15.0


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	$Sprite2D.modulate = modulation_color


func _physics_process(delta: float) -> void:
	if target == null:
		queue_free()
		return
	var direction = global_position.direction_to(target.global_position)
	var desired_velocity : Vector2 = travel_speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * steering_factor * delta
	position += velocity * delta


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage") and area == target:
		queue_free()
		area.take_damage(damage, element)
