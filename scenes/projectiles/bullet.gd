class_name Bullet extends Area2D

var speed : float = 2000.0
var damage : int
var target : Enemy
var element : Global.Element


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	if target == null:
		queue_free()
		return
	var direction = global_position.direction_to(target.global_position)
	position += direction * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		queue_free()
		area.take_damage(damage, element)
