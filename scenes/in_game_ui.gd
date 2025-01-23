extends Control

@export var wave_manager : WaveManager

var total_waves : int

@onready var health_label: RichTextLabel = $TopUi/HealthLabel
@onready var shells_label: RichTextLabel = $TopUi/ShellsLabel
@onready var waves_label: RichTextLabel = $TopUi/WavesLabel

@onready var next_wave_button: Button = %NextWaveButton
@onready var auto_wave_button: Button = %AutoWaveButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_waves = wave_manager.waves.size()
	
	update_wave_label(wave_manager.current_wave_index)
	health_label.text = str(Global.player_health)
	shells_label.text = str(Global.shells)
	
	next_wave_button.pressed.connect(wave_manager.spawn_wave)
	auto_wave_button.pressed.connect(wave_manager.toggle_advancement_mode)
	
	Global.health_changed.connect(update_health_label)
	Global.shells_changed.connect(update_shells_label)
	wave_manager.wave_finished.connect(update_wave_label)


func update_health_label(new_health : int) -> void:
	health_label.text = str(new_health)


func update_shells_label(new_shell_amount : int) -> void:
	shells_label.text = str(new_shell_amount)


func update_wave_label(wave_index : int) -> void:
	waves_label.text = "Wave " + str(wave_index + 1) + "/" + str(total_waves)
