extends Node

signal health_changed(health : int)
signal shells_changed(shells : int)

## These are different elements used for attack and damage calculation + application of gimmicks.
enum Element {
	NONE,
	EARTH,
	LIGHT,
	THUNDER,
	WATER,
	WIND,
}

## These use various Collision layers to not be hit unless you have a tower with that type of collision mask.
enum Gimmick {
	NONE = 1,
	ARMOURED = 2,
	FLYING = 3,
	SPEED = 4,
	STEALTH = 5,
	UNDERGROUND = 6,
}

var player_health : int = 100 : set = set_player_health
var shells : int = 1000 : set = set_shells_amount


func set_player_health(new_health : int) -> void:
	player_health = new_health if new_health > -1 else 0
	health_changed.emit(player_health)
	print("health left: " + str(player_health))
	if player_health == 0:
		print("Died")
		get_tree().quit()


func set_shells_amount(new_amount: int) -> void:
	shells = new_amount
	shells_changed.emit(shells)
	print("Shells: " + str(shells))
