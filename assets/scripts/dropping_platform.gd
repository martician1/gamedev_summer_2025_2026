extends StaticBody2D
class_name DroppingPlatform

@export var platform_collision_shape: CollisionShape2D
@export var area_collision_shape: CollisionShape2D
@export var pivot: Marker2D
@export var sprite: Sprite2D

@export var flash_time := 1.0
@export var number_of_flashes: int = 3
@export var drop_time := 1.0

@export var flash_color: Color = Color("white", 0.7)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not PlayerController:
		return

	# prevent reentering
	area_collision_shape.set_deferred("disabled", true)
	
	var tween = create_tween()
	for i in range(number_of_flashes):
		tween.tween_property(sprite, "modulate", flash_color, flash_time / number_of_flashes / 2.0)
		tween.tween_property(sprite, "modulate", Color("white", 1.0), flash_time / number_of_flashes / 2.0)
	await tween.finished
	
	
	tween = create_tween()
	tween.tween_property(sprite, "modulate", Color("white", 0.0), drop_time)
	create_tween().tween_property(pivot, "rotation", PI / 4.0, drop_time)
	create_tween().tween_property(pivot, "position", Vector2(5.0, 200.0), drop_time)
	
	platform_collision_shape.set_deferred("disabled", true)
	
	await tween.finished
	queue_free()
