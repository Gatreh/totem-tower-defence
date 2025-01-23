class_name Enemy extends Area2D

@export var stats : EnemyStats
@export var color : Color

var health : int : set = set_health
var path_length : float

@onready var path_follow_2d: PathFollow2D = $".."
@onready var path_2d: Path2D = $"../.."
@onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	if stats:
		health = stats.max_health
		color = stats.color
		if stats.gimmicks.size() > 0:
			set_collision_layer_value(1, false)
			for gimmick in stats.gimmicks:
				set_collision_layer_value(gimmick, true)
	color_rect.modulate = color
	path_length = path_2d.curve.get_baked_length()
	path_follow_2d.progress = 0


func _physics_process(delta: float) -> void:
	if stats:
		path_follow_2d.progress += stats.speed * delta
	if path_follow_2d.progress_ratio > 0.98:
		queue_free()
		Global.player_health -= 1


func take_damage(damage: int, element: Global.Element) -> void:
	for resistance in stats.element_resistance:
		if resistance.element == element:
			damage *= (1 - resistance.resistance)
	health -= damage


func set_health(new_health: int) -> void:
	health = clampi(new_health, 0, stats.max_health)
	if health == 0:
		queue_free()
		Global.shells += stats.max_health
