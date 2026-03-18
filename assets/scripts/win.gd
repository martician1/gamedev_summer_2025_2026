extends Control

@export var input_lock_interval := 0.5
var is_input_locked := true

func _ready() -> void:
	await get_tree().create_timer(input_lock_interval).timeout
	is_input_locked = false
	
func _input(_event: InputEvent) -> void:
	if not is_input_locked: 
		get_tree().change_scene_to_file("res://assets/scenes/main_menu.tscn")
