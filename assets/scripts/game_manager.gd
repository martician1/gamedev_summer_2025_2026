# This script is an autoload
extends Node

func load_level(path: String) -> void:
	var gameplay_scene := load("res://assets/scenes/gameplay.tscn") as PackedScene
	var gameplay_instance := gameplay_scene.instantiate()
	var level_node := gameplay_instance.get_node("Level")
	var level_scene := load(path) as PackedScene
	level_node.add_child(level_scene.instantiate())
	get_tree().change_scene_to_node(gameplay_instance)
