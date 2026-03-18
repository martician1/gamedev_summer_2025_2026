extends StaticBody2D

@export var impulse := -400.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.velocity.y = impulse
