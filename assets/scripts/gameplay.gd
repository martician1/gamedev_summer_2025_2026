extends Node2D

signal player_dead(player: PlayerController)

@export var hud: Hud
@export var player: PlayerController
@export var vignette_shader: ColorRect
@export var camera_shake_shader: CameraShake
var exit_door: ExitDoor

@export var max_health := 3:
	set(value):
		max_health = value
		current_health = clamp(current_health, 0, max_health)
		update_hud_max_hearts()

var current_health := 3:
	set(value):
		current_health = clamp(value, 0, max_health)
		update_hud_current_hearts()
		update_vignette_shader()
		if current_health == 0:
			player_dead.emit(player)

@export var critical_health := 1:
	set(value):
		critical_health = value
		update_vignette_shader()

@export var max_keys := 3:
	set(value):
		max_keys = value
		current_keys = clamp(current_keys, 0, max_keys)
		update_hud_max_keys()
		
@export var current_keys := 0:
	set(value):
		current_keys = clamp(value, 0, max_keys)
		update_hud_current_keys()

func update_hud_current_hearts():
	hud.current_hearts = current_health
	
func update_hud_max_hearts():
	hud.max_hearts = max_health

func update_vignette_shader():
	vignette_shader.visible = (current_health <= critical_health)

func update_hud_max_keys():
	hud.max_keys = max_keys

func update_hud_current_keys():
	hud.current_keys = current_keys

func _ready() -> void:
	for key in get_tree().get_nodes_in_group("keys"):
		key.collected.connect(_on_key_collected)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.player_hit.connect(_on_player_hit_by_enemy)
	player.enemy_hit.connect(_on_enemy_hit)

	print_tree_pretty()
	var level = get_tree().get_first_node_in_group("levels") as BaseLevel
	level.falloff.connect(_on_player_falloff)
	exit_door = get_tree().get_first_node_in_group("exit_doors") as ExitDoor
	exit_door.player_exit.connect(_on_player_exit)
	player_dead.connect(_on_player_dead)
	
	update_hud_max_hearts()
	update_hud_current_hearts()
	update_vignette_shader()
	
	update_hud_max_keys()
	update_hud_current_keys()
	
func _on_key_collected():
	current_keys += 1
	if current_keys == max_keys:
		exit_door.open()

func _on_player_hit_by_enemy(enemy: Enemy):
	current_health -= enemy.damage
	var tween = create_tween()
	tween.tween_method(camera_shake_shader.set_shake_strength, 0.0, 0.2, 1.0)
	tween.tween_method(camera_shake_shader.set_shake_strength, 0.2, 0.0, 1.0)

func _on_player_falloff():
	if player.state != player.State.Hurt:
		current_health -= 1

func _on_player_dead(_player: PlayerController):
	get_tree().change_scene_to_file.call_deferred("res://assets/scenes/lose.tscn")	

func _on_player_exit(_player: PlayerController):
	get_tree().change_scene_to_file.call_deferred("res://assets/scenes/win.tscn")

func _on_enemy_hit(enemy: Enemy):
	enemy.die()
