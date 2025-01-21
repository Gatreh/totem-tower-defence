class_name Enemy extends Area2D

var max_health : int = 15
var health : int = max_health : set = set_health
var element : Global.Element
## Resistance denoted by type Global.Element : value, calculated as % meaning 100 is immunity to that type.
var element_resistance : = {
	Global.Element.LIGHT : 1
}
var gimmicks : Array[Global.Gimmick]

var path : PathFollow2D


func _ready() -> void:
	if gimmicks.size() > 0:
		set_collision_layer_value(1, false)
		for gimmick in gimmicks:
			set_collision_layer_value(gimmick, true)


func _physics_process(delta: float) -> void:
	position += Vector2.DOWN * 50.0 * delta


func take_damage(damage: int, element: Global.Element) -> void:
	if element_resistance.has(element):
		damage *= 1 * element_resistance[element]
	health -= damage


func set_health(new_health: int) -> void:
	health = clampi(new_health, 0, max_health)
	if health == 0:
		queue_free()
