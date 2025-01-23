class_name Totem extends Resource
## This is a resource for totem statistics to be applied to [TotemPole] scenes.
##
## This resource is meant to be extended by other resources to pre-set the stats so they can be used by
## the totem pole.

## The name of the Totem
@export var name : String
## The Base texture of the totem
@export var base_texture: Texture2D = preload("res://assets/totem.svg")
## The colour to change the base_texture with.
@export var modulation_color: Color = Color.WHITE

@export_category("Tier 1 Stats")
## The base damage that is applied to the [TotemPole].
@export var base_damage : int = 15
## The base attack speed that is applied to the [TotemPole]. Espressed in attacks per second.
@export var base_attack_speed: float = 1.0
## The base range that is applied to the [TotemPole].
@export var base_range : int = 240
## The [member AttackType] that is applied to the [TotemPole].
@export var attack_type : AttackType

@export_category("Tier 2 Stats")
@export var damage_multiplier : float = 1.2
@export var attack_speed_multiplier : float = 1.2
@export var range_multiplier : float = 1.2
## The ["global.gd".Element] that is applied to the [TotemPole].
@export var element : Global.Element
@export var gimmick : Global.Gimmick = Global.Gimmick.NONE

@export_category("Tier 3 Stats")

## This defines the different types of attacks that a [TotemPole] can use.
enum AttackType {
	## This attack gets an initial target and then jumps from enemy to enemy. Starts at 3 jumps.
	CHAIN, 
	## This is an attack that does multiple small attacks each time it attacks.
	FLURRY, 
	## This attack does an area of effect that deals damage to every enemy in the area.
	QUAKE, 
	## This deals a lot of damage as an attack that travels from the tower to the enemy.
	SNIPE, 
	## This deals a lot of damage as an attack that falls from the sky.
	STRIKE,
}
