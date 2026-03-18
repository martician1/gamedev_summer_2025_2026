extends AnimatedSprite2D

@export var enemy: Enemy
@export var effect_animator: AnimationPlayer

func _process(_delta: float) -> void:
	if enemy.state == enemy.State.DYING:
		effect_animator.play("die", -1, enemy.die_time)
	
	if enemy.velocity.x > 0:
		flip_h = false
	elif enemy.velocity.x < 0:
		flip_h = true

	if enemy.is_on_floor():
		if enemy.velocity.x == 0:
			play("idle")
		else:
			play("walk")
	else:
		play("jump")
