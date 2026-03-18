extends Area2D
class_name ExitDoor

signal player_exit(player: PlayerController)

@export var sprite: Sprite2D
@export var open_texture: Texture2D
@export var closed_textured: Texture2D
@export var collision_shape: CollisionShape2D
@export var initially_open := false

func _ready() -> void:
	if initially_open:
		open()
	else:
		close()

func open():
	collision_shape.set_deferred("disabled", false)
	sprite.texture = open_texture

func close():
	collision_shape.set_deferred("disabled", true)
	sprite.texture = closed_textured

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController:
		player_exit.emit(body as PlayerController)
