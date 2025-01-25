extends Node

var base_health : int = 150
var scaling : float = 1.52

func _ready() -> void:
	for n in 8:
		print("Wave: " +str(n + 1)+ "  Health: " + str(base_health * pow(scaling, n)))
