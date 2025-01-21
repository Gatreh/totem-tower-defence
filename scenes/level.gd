extends Control

@export var totem : Totem
@onready var placement_area : Area2D = $TestMap1/PlacementArea


func _ready() -> void:
	placement_area.valid_position.connect(func(pos: Vector2):
		var new_totem_pole = TotemPole.new()
		new_totem_pole.create_totem(self, pos, totem)
	)
