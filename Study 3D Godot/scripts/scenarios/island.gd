extends Node

func _unhandled_key_input(event : InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
