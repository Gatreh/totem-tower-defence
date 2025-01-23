extends Bullet

var attack_range : float

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	$Sprite2D.modulate = modulation_color


func _physics_process(delta: float) -> void:
	# Needs range calculation to swap between scale and pixels.
	if collision_shape_2d.shape.radius >= attack_range:
		queue_free()
	# Expand to radius in one second
	collision_shape_2d.shape.radius += attack_range * delta
	sprite_2d.scale += Vector2(2,2) * delta


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(damage, element)
