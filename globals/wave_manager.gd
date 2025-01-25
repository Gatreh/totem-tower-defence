class_name WaveManager 
extends Node

signal wave_started(wave_index: int)
signal wave_finished(wave_index: int)
signal all_waves_finished

enum AdvancementMode { MANUAL, AUTO}

@export var advancement_mode: AdvancementMode = AdvancementMode.MANUAL
@export var path : Path2D
@export var waves : Array[WaveData]

var current_wave_index : int = 0
var enemies_on_path : int = 0
var wave_in_progress : bool = false


func _ready() -> void:
	wave_finished.connect(_on_wave_finished)


func spawn_wave() -> void:
	if not wave_in_progress:
		wave_in_progress = true
		wave_started.emit(current_wave_index)
		
		var wave : WaveData = waves[current_wave_index]
		for enemies in wave.enemy_spawns:
			for n in enemies.spawn_count:
				spawn_enemy(enemies.enemy_scene)
				await get_tree().create_timer(enemies.spawn_time).timeout


func spawn_enemy(enemy_scene: PackedScene) -> void:
	if not path:
		push_error("PathFollow2D is not assigned in WaveManager")
		return
	if not enemy_scene:
		push_error("Enemy scene is not assigned in WaveData")
		return
	
	var enemy := enemy_scene.instantiate()
	var path_follow = PathFollow2D.new()
	path_follow.rotates = false
	
	path_follow.add_child(enemy)
	path.add_child(path_follow)
	
	enemies_on_path += 1
	enemy.tree_exited.connect(func(): 
		enemies_on_path -= 1
		if enemies_on_path == 0:
			wave_finished.emit(current_wave_index)
	)


func toggle_advancement_mode() -> void:
	advancement_mode = AdvancementMode.AUTO\
					if advancement_mode == AdvancementMode.MANUAL else\
					AdvancementMode.MANUAL
	if advancement_mode == AdvancementMode.AUTO and not wave_in_progress:
		spawn_wave()


func _on_wave_finished(wave_index: int) -> void:
	wave_in_progress = false
	current_wave_index = wave_index + 1
	if current_wave_index >= waves.size():
		all_waves_finished.emit()
	elif advancement_mode == AdvancementMode.AUTO:
		spawn_wave()
