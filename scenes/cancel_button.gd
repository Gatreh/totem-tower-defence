class_name UICancelButton extends TextureButton

@onready var cancel_margin_container: MarginContainer = $"../CancelMarginContainer"

func toggle_visibilty(value : bool) -> void:
	visible = value
	cancel_margin_container.visible = not value
