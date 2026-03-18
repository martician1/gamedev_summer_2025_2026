extends Control

func _on_play_pressed() -> void:
	GameManager.load_level("res://assets/scenes/level.tscn")

func _on_options_pressed() -> void:
	print("Not implemented")

func _on_quit_pressed() -> void:
	get_tree().quit()
