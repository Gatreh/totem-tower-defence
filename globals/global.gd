extends Node

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
