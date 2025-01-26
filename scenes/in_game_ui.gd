extends Control

@export var wave_manager : WaveManager

var total_waves : int

@onready var health_label: RichTextLabel = $TopUi/HealthLabel
@onready var shells_label: RichTextLabel = $TopUi/ShellsLabel
@onready var waves_label: RichTextLabel = $TopUi/WavesLabel

@onready var next_wave_button: Button = %NextWaveButton
@onready var auto_wave_button: Button = %AutoWaveButton
@onready var cancel_button: UICancelButton = %CancelButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_waves = wave_manager.waves.size()
	
	update_wave_label(wave_manager.current_wave_index)
	update_health_label(Global.player_health)
	update_shells_label(Global.shells)
	
	next_wave_button.pressed.connect(wave_manager.spawn_wave)
	next_wave_button.gui_input.connect(_on_button_gui_input)
	auto_wave_button.pressed.connect(wave_manager.toggle_advancement_mode)
	auto_wave_button.gui_input.connect(_on_button_gui_input)
	cancel_button.gui_input.connect(_on_cancel_gui_input)
	
	Global.health_changed.connect(update_health_label)
	Global.shells_changed.connect(update_shells_label)
	wave_manager.wave_finished.connect(update_wave_label)


func cancel_placement() -> void:
	get_tree().get_first_node_in_group("mouse_draggable").delete()


func update_health_label(new_health : int) -> void:
	health_label.text = " " + str(new_health)


func update_shells_label(new_shell_amount : int) -> void:
	shells_label.text = " " + str(new_shell_amount)


func update_wave_label(wave_index : int) -> void:
	waves_label.text = "Wave " + str(wave_index + 1 if wave_index < total_waves else total_waves)\
					 + "/" + str(total_waves)


func _on_button_gui_input(event: InputEvent):
	var is_right_mouse_button : bool = (
		event is InputEventMouseButton and 
		event.button_index == MOUSE_BUTTON_RIGHT and 
		event.is_pressed() 
	)
	var has_mouse_draggable : bool = get_tree().get_nodes_in_group("mouse_draggable").size() > 0
	if is_right_mouse_button and has_mouse_draggable:
		get_tree().get_first_node_in_group("mouse_draggable").delete()


func _on_cancel_gui_input(event: InputEvent):
	var is_left_mouse_button : bool = (
		event is InputEventMouseButton and 
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.is_pressed() 
	)
	if is_left_mouse_button:
		cancel_placement()
